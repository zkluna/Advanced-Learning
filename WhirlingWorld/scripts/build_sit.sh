#! /bin/sh

# 获取工程路径
DIRECTORY=$(dirname "$0")
PARENT=$(dirname "$DIRECTORY")
project_dir=$(cd "$PARENT" && pwd -P)

# 修改Constants.m 
# netWorkTool=$project_dir/LifeTouch/Foundation/Constants/Constants.m
# sed -i ""  '/^[const NSString]/d' $netWorkTool
# sed -i "" '$ a\ 
# const NSString \*HOST_ADDRESS=@\"http:\/\/14.23.109.92:9999\";' $netWorkTool

# 执行打包脚本打包
iOS_build=$DIRECTORY/iOS_build
chmod a+x $iOS_build
$iOS_build -f $project_dir/LoansSupermarket.xcworkspace -o $project_dir/sit

# 上传IPA包

# 上传到蒲公英
# curl -F "file=@$project_dir/sit/LoansSupermarket.ipa" -F "uKey=fe78059fd299052873bce6c4208a81c0" -F "_api_key=f04a6835f68bd78d0ec0b8763fd7ed96" https://qiniu-storage.pgyer.com/apiv1/app/upload

# 上传到fir
fir publish $project_dir/sit/LoansSupermarket.ipa -T fcadde6eb8872fba1fce16d406fca600
