#!/usr/bin/python3
## changed to python3

import subprocess, sys, os, argparse
from pxr import *
from validateMesh import validateMesh
from validateMaterial import validateMaterial

## No changes
def validateFile(file, verbose, errorData):
    stage = Usd.Stage.Open(file)
    success = True
    predicate = Usd.TraverseInstanceProxies(Usd.PrimIsActive & Usd.PrimIsDefined & ~Usd.PrimIsAbstract)
    for prim in stage.Traverse(predicate):
        if prim.GetTypeName() == "Mesh":
            success = validateMesh(prim, verbose, errorData) and success
        if prim.GetTypeName() == "Material":
            success = validateMaterial(prim, verbose, errorData) and success
    return success

## More verbose verbose mode
def runValidators(filename, verboseOutput, errorData):
    checker = UsdUtils.ComplianceChecker(arkit=True, 
            skipARKitRootLayerCheck=False, rootPackageOnly=False, 
            skipVariants=False, verbose=verboseOutput) #<- changed to pass verboseOutput through

    
    checker.CheckCompliance(filename)

    if verboseOutput:
        print("Rules Being Checked by usdchecker:")
        # checker.DumpAllRules() line failed with error: 
        # for ruleNum, rule in enumerate(GetBaseRules()):   
        # NameError: name 'GetBaseRules' is not defined
        for rule in checker._rules:
            print(rule)
        print("-----")

    errors = checker.GetErrors()
    failedChecks = checker.GetFailedChecks()
    warnings = checker.GetWarnings()
    
    if verboseOutput:
        for warning in warnings:
            print(warning)
        for error in errors:
            print(error)
        for failure in failedChecks:
            print(failure)
        print("-----")
    for rule in checker._rules:
        error = rule.__class__.__name__
        failures = rule.GetFailedChecks()
        if len(failures) > 0:
            errorData.append({ "code": "PXR_" + error })
            errors.append(error)
    if verboseOutput:
        print("Will be exported to outErrorList")
        print(errorData)
        print("----")

    usdCheckerResult = len(errors) == 0
    mdlValidation = validateFile(filename, verboseOutput, errorData)

    success = usdCheckerResult and mdlValidation
    print("usdARKitChecker: " + ("[Pass]" if success else "[Fail]") + " " + filename)

## No changes
def main(argumentList, outErrorList=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--verbose", "-v", action='store_true', help="Verbose mode.")
    parser.add_argument('files', nargs='*')
    args=parser.parse_args(argumentList)

    verboseOutput = args.verbose
    totalSuccess = True
    for filename in args.files:
        errorData = []
        runValidators(filename, verboseOutput, errorData)
        if outErrorList is not None:
            outErrorList.append({ "file": filename, "errors": errorData })
        totalSuccess = totalSuccess and len(errorData) == 0

    if totalSuccess:
        return 0
    else:
        return 1

if __name__ == '__main__':
    argumentList = sys.argv[1:]
    sys.exit(main(argumentList))