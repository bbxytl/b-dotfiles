#!/usr/bin/env python
# encoding: utf-8
# coding style: pep8
# ====================================================
#   Copyright (C)2018 All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : swagger-description-new.py
#   Last Modified : 2018-10-31 19:28
#   Describe      :
#
# 运行下面的指令
#  mkdir $HOME/.local/bin
#  ln -s `pwd`/swagger-description-new.py $HOME/.local/bin/swagger-desc-new
#  chmod +x $HOME/.local/bin/swagger-desc-new
#
# 将下面的内容放到 .bashrc 里, zsh 放到 .zshrc
#  export PATH=$PATH:$HOME/.local/bin
#  # 只生成固定tag或operationId的path, 不指定 tag/operationId 时 生成全部的
#  swaggergeopt() {
#      swagger_file=$1;
#      swagger generate spec -o $swagger_file;
#      swagger-desc-new $@;
#      sed "s/____contact__name___/your_name/g" $1 | sed "s/____contact__email___/your_email/g" > "$1.json";
#      mv "$1.json"  $1
#  }
#
# 使用方法：
# 在 go 的某个项目里运行：
#  - 生成所有的内容
#     swaggergeopt swagger.json
#  - 生成指定tag或operationId的内容
#     swaggergeopt swagger.json tag1 tag2 operationId1 operationId2
# ====================================================

import sys
import os
import json
# from pprint import pprint

allTags = {}

def opt_dict(key, fp):
    if not isinstance(fp, dict):
        return fp
    if key != "properties" and key != "responses" and key != "schema":
        # if not fp.has_key("description") and not fp.has_key('$ref'):
        if not fp.has_key("description"):
            desc = key
            # print desc
            if fp.has_key("name") and isinstance(fp["name"], str):
                desc = fp["name"]
            fp["description"] = desc

    for k, v in fp.items():
        if isinstance(v, dict):
            fp[k] = opt_dict(k, v)
            continue
        if isinstance(v, list):
            fp[k] = opt_list(k, v)

    return fp

def opt_list(key, fp):
    if not isinstance(fp, list):
        return fp
    for i in range(len(fp)):
        v = fp[i]
        if isinstance(v, list):
            fp[i] = opt_list(v)
            continue
        if isinstance(v, dict):
            fp[i] = opt_dict("description",v)
    return fp


def description(file):
    # print arg
    outfile = file+".opt.json"
    with open(file) as var:
        fp = json.load(var)

        if not fp.has_key("info"):
            fp["info"] = {"description": "info", "title": "title", "version":"0.0.0"}
        if not fp["info"].has_key("version"):
            fp["info"]["version"] = "0.0.0"
        if not fp["info"].has_key("description"):
            fp["info"]["description"] = "info"
        if not fp["info"].has_key("title"):
            fp["info"]["title"] = "info"

        # if not fp["info"].has_key("contact"):
        fp["info"]["contact"] = {}
        contact = fp["info"]["contact"]
        if not contact.has_key("name"):
            contact["name"] = "____contact__name___"
        if not contact.has_key("email"):
            contact["email"] = "____contact__email___"
        ############# paths ################
        paths = {}
        if fp.has_key("paths"):
            paths = fp["paths"]

        for k0 in paths.keys():
            v0 = paths[k0]
            if not isinstance(v0, dict):
                continue
            for k1 in v0.keys():
                v1 = v0[k1]
                if k1 == "get" or k1 == "post" :
                    if not isinstance(v1, dict):
                        continue
                    summary = ""
                    if v1.has_key("operationId"):
                        summary = v1["operationId"]
                    if v1.has_key("tags"):
                        tags = v1["tags"]
                        if isinstance(tags, list):
                            for tag in tags:
                                if not allTags.has_key(tag):
                                    allTags[tag] = {}
                                allTags[tag][summary] = 1

                    if v1.has_key("summary"):
                        summary = v1["summary"]
                    v1["summary"] = summary

                    if v1.has_key("parameters"):
                        parameters = v1["parameters"]
                        if isinstance(parameters, dict):
                            v1["parameters"] = opt_dict("parameters", parameters)
                        if isinstance(parameters, list):
                            v1["parameters"] = opt_list("parameters", parameters)


        ############# definitions ################
        definitions = {}
        if fp.has_key("definitions"):
            definitions = fp["definitions"]
        for k, v in definitions.items():
            if isinstance(v, dict):
                definitions[k] = opt_dict(k, v)
            if isinstance(v, list):
                definitions[k] = opt_list(k, v)


        ############# responses ################
        responses = {}
        if fp.has_key("responses"):
            responses = fp["responses"]
        for k0, v0 in responses.items():
            if isinstance(v0, dict):
                responses[k0] = opt_dict(k0, v0)
            if isinstance(v0, list):
                responses[k0] = opt_list(k0, v0)


        ############# write ################
        with open(outfile, 'w') as out:
            json.dump(fp, out)

        os.system("mv " + outfile + " " + file)


def collect_list_ref(ls, structMap):
    if not isinstance(ls, list):
        return structMap
    for lsVal in ls:
        if isinstance(lsVal, dict):
            structMap = collect_dict_ref(lsVal, structMap)
        if isinstance(lsVal, list):
            structMap = collect_list_ref(lsVal, structMap)
    return structMap

def collect_dict_ref(obj, structMap ):
    if not isinstance(obj, dict):
        return structMap
    for objKey, objVal in obj.items():
        if isinstance(objVal, dict):
            structMap = collect_dict_ref(objVal, structMap)
        if isinstance(objVal, list):
            structMap = collect_list_ref(objVal, structMap)
        if objKey == '$ref':
            st = objVal.split("/")
            if len(st) > 0:
                structMap[st[-1]] = 1
            # print objKey, objVal, st[-1]
    return structMap

MaxStackDef = 10000000
def merge_struct(pathsStructMap, allStructMap):
    outMap = {}
    for pathstKey in pathsStructMap.keys():
        outMap, stackDef = merge_struct_v2(pathstKey, allStructMap, outMap, MaxStackDef)
    return outMap

def merge_struct_v2(key, allStructMap, outMap, stackDef):
    # print stackDef, key, outMap.keys()
    stackDef = stackDef - 1
    if stackDef <= 0:
        return outMap, stackDef
    if allStructMap.has_key(key):
        outMap[key] = 1
        # if key == "getCountriesByCitiesResponseWrapper":
            # print key, allStructMap[key].keys()
        for k in allStructMap[key].keys():
            outMap, stackDef = merge_struct_v2(k, allStructMap, outMap, stackDef)
    return outMap, stackDef


def merge_map(allStructMap, structMap):
    for key, val in structMap.items():
        if not allStructMap.has_key(key):
            allStructMap[key] = {}
        if not isinstance(val, dict):
            continue
        for k, v in val.items():
            allStructMap[key][k] = v
    return allStructMap

def operation(file, operationIds):
    # print file, operationIds
    outfile = file+".opt.json"
    with open(file) as var:
        fp = json.load(var)

        # print arg
        ############# paths ################
        pathsOriMap = {}
        pathsOutMap = {}
        pathsStructMap = {}

        if fp.has_key("paths"):
            pathsOriMap = fp["paths"]

        for pathKey in pathsOriMap.keys():
            # print "pathKey ===> ", pathKey
            pathVal = pathsOriMap[pathKey]
            if not isinstance(pathVal, dict):
                continue
            for method in pathVal.keys():
                body = pathVal[method]
                if method== "get" or method== "post" :
                    if not isinstance(body, dict):
                        break
                    flag = 0
                    if body.has_key("operationId"):
                        if body["operationId"] in operationIds:
                            flag = 1
                    if body.has_key("tags"):
                        tags = body["tags"]
                        # print "tags ===> ", tags, operationIds
                        if isinstance(tags, list):
                            for tag in tags:
                                if tag in operationIds:
                                    flag = 1
                                    break
                    if flag == 0 :
                        break

                    pathsOutMap[pathKey] = pathVal
                    if body.has_key("parameters"):
                        params = body["parameters"]
                    structMap={}
                    if isinstance(params, dict):
                        structMap = collect_dict_ref(params, structMap)
                    if isinstance(params, list):
                        structMap = collect_list_ref(params, structMap)
                    for s in structMap.keys():
                        pathsStructMap[s] = structMap[s]
                    if body.has_key("responses"):
                        resps = body["responses"]
                    structMap={}
                    if isinstance(resps, dict):
                        structMap = collect_dict_ref(resps, structMap)
                    if isinstance(resps, list):
                        structMap = collect_list_ref(resps, structMap)
                    for s in structMap.keys():
                        pathsStructMap[s] = structMap[s]

        fp["paths"] = pathsOutMap
        # printMapKey(pathsOutMap, "========== pathsOutMap")
        # printMapKey(pathsStructMap, "========== pathsStructMap")
        # print "=========================="

        allStructMap = {}
        ################# responses #################
        respOriMap = {}
        if fp.has_key("responses"):
            respOriMap = fp["responses"]

        structMap={}
        if isinstance(respOriMap, dict):
            for respKey, respVal in respOriMap.items():
                stMap = {}
                stMap = collect_dict_ref(respVal, stMap)
                structMap[respKey] = stMap
                # if respKey == "getCountriesByCitiesResponseWrapper":
                    # print "==", respKey, stMap.keys()

        # printMapKey(structMap, "==========resp structMap")
        allStructMap = merge_map(allStructMap, structMap)

        ################# definitions #################
        defOriMap = {}
        if fp.has_key("definitions"):
            defOriMap = fp["definitions"]

        structMap={}
        if isinstance(defOriMap, dict):
            for defKey, defVal in defOriMap.items():
                stMap = {}
                stMap = collect_dict_ref(defVal, stMap)
                structMap[defKey] = stMap

        # printMapKey(structMap, "==========def structMap")
        allStructMap = merge_map(allStructMap, structMap)
        # printMapKey(allStructMap["getEuropeRailHomeResponse"], "=====getEuropeRailHomeResponse=====allStructMap")

        ############### merge ######################
        respOutMap = {}
        defOutMap = {}
        outStructKeyMap = merge_struct(pathsStructMap, allStructMap)
        # print outStructKeyMap.keys()
        for key in outStructKeyMap.keys():
            if key in respOriMap.keys():
                respOutMap[key] = respOriMap[key]
            if key in defOriMap.keys():
                defOutMap[key] = defOriMap[key]

        fp["responses"] = respOutMap
        fp["definitions"] = defOutMap
        # printMapKey(respOutMap, "respOutMap")
        # printMapKey(defOutMap, "defOutMap")

        ############# write ################
        with open(outfile, 'w') as out:
            json.dump(fp, out)

        os.system("mv " + outfile + " " + file)

def printMapKey(m, msg):
    print "========= ", msg
    for k in m.keys():
        print k

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(0)
    swaggerFile = sys.argv[1]
    operationIdsOrTags = sys.argv[2:]
    description(swaggerFile)
    if len(operationIdsOrTags) > 0:
        operation(swaggerFile, operationIdsOrTags)
    else:
        print "======================="
        print "tags, operationIds: "
        for tag, opts in allTags.items():
            optsStr = ""
            for opt in opts:
                optsStr = optsStr + opt + ", "
            print tag, ":\t", optsStr
        print "======================="

