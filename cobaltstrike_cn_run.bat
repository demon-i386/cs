@echo 主程4.0 汉化插件版本0.0.1beta
java -XX:ParallelGCThreads=4 -XX:+AggressiveHeap -XX:+UseParallelGC -Xms512M -Xmx1024M -Dfile.encoding=UTF-8 -javaagent:CobaltStrikeCN.jar -jar cobaltstrike.jar $*