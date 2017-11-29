#!/bin/bash

# Your configuration information

target_name="whirlingworld.xcodeproj" # 有效值 ****.xcodeproj / ****.xcworkspace (cocoapods项目)
project_name="whirlingworld" # 工程名
work_type="project" # 有效值 project / workspace (cocoapods项目)
api_token="" # fir token

sctipt_path=$(cd `dirname $0`; pwd)
echo sctipt_path=${sctipt_path}
work_path=$(dirname "$sctipt_path")
out_base_path="build"
out_date=`date "+%Y-%m-%d %H:%M:%S"`

rm -rf ${work_path}/${out_base_path}

#cd ../
#pod install --no-repo-update
#cd ${sctipt_path}

out_path=${work_path}/${out_base_path}
mkdir -p ${out_path}
echo ${out_date} > ${out_path}/info.txt

if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
source $HOME/.rvm/scripts/rvm
rvm use system
fi

# xcodebuild打包脚本 1、先clean项目 2、然后archive 3、导出
xcodebuild -$work_type ${work_path}/$target_name -scheme $project_name -configuration Release -sdk iphoneos clean

xcodebuild -$work_type ${work_path}/$target_name -scheme $project_name -configuration Release -archivePath ${out_path}/$project_name.xcarchive archive
#echo "\033[1;31m$(dirname $(pwd))/$project_name/Info.plist \033[0m"
xcodebuild -exportArchive -archivePath ${out_path}/$project_name.xcarchive -exportPath ${out_path} -exportOptionsPlist ${sctipt_path}/xcodebuild_config.plist 

echo ${out_path}/$project_name.ipa

if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
source ~/.rvm/scripts/rvm
rvm use default
fi

fir p ${out_path}/$project_name.ipa -T $api_token

exit 0
