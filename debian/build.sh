#!/bin/bash

# Clean up ./debian/output
rm -rf debian/output
mkdir debian/output

# Sources of flogger-0.5.1.jar and flogger-system-backend-0.5.1.jar are under ./api
cd api

# flogger has a very interesting way to generate the platform_provider.jar directly from a java binary
# This is a replacement for //api:gen_platform_provider
javac -classpath /usr/share/java/asm.jar platformprovider/main/java/com/google/common/flogger/backend/PlatformProviderGenerator.java
java -classpath ./platformprovider/main/java:/usr/share/java/asm.jar com.google.common.flogger.backend.PlatformProviderGenerator ./platform_provider.jar

# Build flogger-0.5.1.jar
ln -sf ../debian/flogger.pom.xml ./pom.xml
mvn package -Dmaven.test.skip=true
cp ./target/flogger-0.5.1.jar ../debian/output/

# Build flogger-system-backend-0.5.1.jar
ln -sf ../debian/flogger-system-backend.pom.xml ./pom.xml
mvn package -Dmaven.test.skip=true
cp ./target/flogger-system-backend-0.5.1.jar ../debian/output/

# Sources of google-extensions-0.5.1.jar are under ./google
cd ../google

# Build google-extensions-0.5.1.jar
ln -sf ../debian/google-extensions.pom.xml ./pom.xml
mvn package -Dmaven.test.skip=true
cp ./target/google-extensions-0.5.1.jar ../debian/output/
