#!/bin/sh

#  批量打包脚本.sh
#  LotteryUnion
#
#  Created by xhd945 on 15/12/23.
#  Copyright © 2015年 TalkWeb. All rights reserved.




#xcodebuild -workspace /Users/tangxiahui/彩票联盟/ios/ios/新版/LotteryUnion/LotteryUnion.xcworkspace -scheme LotteryUnion -configuration Release archive -archivePath ./archive
channels=( 700001 700002 700003 )
for i in ${channels[@]}
do
/usr/libexec/PlistBuddy -c "Set :Channel ""$i" ./archive.xcarchive/Products/Applications/*.app/info.plist
rm -Rf ./$i.ipa
xcodebuild -exportArchive —exportFormat ipa -archivePath ./archive.xcarchive -exportPath ./$i.ipa -exportWithOriginalSigningIdentity
done
rm -Rf ./archive.xcarchive
