#!/bin/bash

cd ${{ github.workspace }}/project
#共存
sed -i 's/com.github.tvbox.osc/com.github.tvbox.osc.jy/g' ${{ github.workspace }}/project/app/build.gradle
#xwalk修复
#sed -i 's/download.01.org\/crosswalk\/releases\/crosswalk\/android\/maven2/raw.githubusercontent.com\/lm317379829\/TVBoxDIY\/main/g' ${{ github.workspace }}/project/build.gradle
#名称修改
#sed -i 's/TVBox/极影视/g' ${{ github.workspace }}/project/app/src/main/res/values/strings.xml
#图标修改
#cp $CURRENT_DIR/DIY/app_icon.png ${{ github.workspace }}/project/app/src/main/res/drawable-hdpi/app_icon.png
#cp $CURRENT_DIR/DIY/app_icon.png ${{ github.workspace }}/project/app/src/main/res/drawable-xhdpi/app_icon.png
#cp $CURRENT_DIR/DIY/app_icon.png ${{ github.workspace }}/project/app/src/main/res/drawable-xxhdpi/app_icon.png
#mv $CURRENT_DIR/DIY/app_icon.png ${{ github.workspace }}/project/app/src/main/res/drawable-xxxhdpi/app_icon.png
#背景修改
#mv $CURRENT_DIR/DIY/app_bg.png ${{ github.workspace }}/project/app/src/main/res/drawable/app_bg.png
#取消选集全屏
#sed -i 's/if (showPreview \&\& !fullWindows) toggleFullPreview/\/\/if (showPreview \&\& !fullWindows) toggleFullPreview/g' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/ui/activity/DetailActivity.java
#缩略图清晰度修改
#sed -i 's/mContext, 400/mContext, 500/g' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/ui/activity/DetailActivity.java
#sed -i 's/mContext, 300/mContext, 400/g' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/ui/activity/DetailActivity.java
#sed -i 's/mContext, 400/mContext, 500/g' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/ui/adapter/GridAdapter.java
#sed -i 's/mContext, 300/mContext, 400/g' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/ui/adapter/GridAdapter.java
#sed -i 's/mContext, 400/mContext, 500/g' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/ui/adapter/HistoryAdapter.java
#sed -i 's/mContext, 300/mContext, 400/g' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/ui/adapter/HistoryAdapter.java
#添加PY支持
wget --no-check-certificate -qO- "https://raw.githubusercontent.com/UndCover/PyramidStore/main/aar/pyramid-1011.aar" -O ${{ github.workspace }}/project/app/libs/pyramid.aar
sed -i "/thunder.jar/a\    implementation files('libs@pyramid.aar')" ${{ github.workspace }}/project/app/build.gradle
sed -i 's#@#\\#g' ${{ github.workspace }}/project/app/build.gradle
sed -i 's#pyramid#\\pyramid#g' ${{ github.workspace }}/project/app/build.gradle
echo "" >>${{ github.workspace }}/project/app/proguard-rules.pro
echo "" >>${{ github.workspace }}/project/app/proguard-rules.pro
echo "#添加PY支持" >>${{ github.workspace }}/project/app/proguard-rules.pro
echo "-keep public class com.undcover.freedom.pyramid.** { *; }" >>${{ github.workspace }}/project/app/proguard-rules.pro
echo "-dontwarn com.undcover.freedom.pyramid.**" >>${{ github.workspace }}/project/app/proguard-rules.pro
echo "-keep public class com.chaquo.python.** { *; }" >>${{ github.workspace }}/project/app/proguard-rules.pro
echo "-dontwarn com.chaquo.python.**" >>${{ github.workspace }}/project/app/proguard-rules.pro
sed -i '/import com.orhanobut.hawk.Hawk;/a\import com.undcover.freedom.pyramid.PythonLoader;' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/base/App.java
sed -i '/import com.orhanobut.hawk.Hawk;/a\import com.github.catvod.crawler.SpiderNull;' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/base/App.java
sed -i '/PlayerHelper.init/a\        PythonLoader.getInstance().setApplication(this);' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/base/App.java
sed -i '/import android.util.Base64;/a\import com.github.catvod.crawler.SpiderNull;' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/import android.util.Base64;/a\import com.undcover.freedom.pyramid.PythonLoader;' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/private void parseJson(String apiUrl, String jsonStr)/a\        PythonLoader.getInstance().setConfig(jsonStr);' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/public Spider getCSP(SourceBean sourceBean)/a\        if (sourceBean.getApi().startsWith(\"py_\")) {\n        try {\n            return PythonLoader.getInstance().getSpider(sourceBean.getKey(), sourceBean.getExt());\n        } catch (Exception e) {\n            e.printStackTrace();\n            return new SpiderNull();\n        }\n    }' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/public Object\[\] proxyLoca/a\    try {\n        if(param.containsKey(\"api\")){\n            String doStr = param.get(\"do\").toString();\n            if(doStr.equals(\"ck\"))\n                return PythonLoader.getInstance().proxyLocal(\"\",\"\",param);\n            SourceBean sourceBean = ApiConfig.get().getSource(doStr);\n            return PythonLoader.getInstance().proxyLocal(sourceBean.getKey(),sourceBean.getExt(),param);\n        }else{\n            String doStr = param.get(\"do\").toString();\n            if(doStr.equals(\"live\")) return PythonLoader.getInstance().proxyLocal(\"\",\"\",param);\n        }\n    } catch (Exception e) {\n        e.printStackTrace();\n    }\n' ${{ github.workspace }}/project/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
#FongMi的jar支持
echo "" >>${{ github.workspace }}/project/app/proguard-rules.pro
echo "-keep class com.google.gson.**{*;}" >>${{ github.workspace }}/project/app/proguard-rules.pro

echo 'DIY end'
