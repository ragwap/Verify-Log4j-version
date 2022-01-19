#!/bin/bash
TIMESPTAMP=$(date "+%Y.%m.%d-%H.%M.%S")
echo "Running log4j-core JARs finder in $(pwd)"
mkdir Log4j-verification
echo "log4j-core JARs finder script (CVE-2021-44228)" | tee -a "Log4j-verification/log4j_mitigation_$TIMESPTAMP.log"
JAR_FILES=$(find . -name '*.jar' -o -name '*.war' -o -name '*.zip')
for JAR_FILE in $JAR_FILES
do
	echo "[-] Checking: $JAR_FILE" >> "Log4j-verification/log4j_mitigation_$TIMESPTAMP.log"
	CONTAINS_JNDI_LOOKUP=$(unzip -l "$JAR_FILE" | grep "log4j-core")
	if [ -n "$CONTAINS_JNDI_LOOKUP" ]; then
		echo "Found log4j-core in: $JAR_FILE"
		#POM_FILE=$(basename "$JAR_FILE")
		echo "<!--Log4j version for $JAR_FILE-->" >> Log4j-verification/Log4j-versions.xml
		unzip -p $JAR_FILE META-INF/maven/org.apache.logging.log4j/log4j-core/pom.xml | grep -A 5 '<parent>' >> Log4j-verification/Log4j-versions.xml
	fi
done
echo "Execution completed"
