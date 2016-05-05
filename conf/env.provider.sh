# Environment file which sources other provider-specific environment files

echo "Sourcing provider-specific environment files..."

PROVIDER_DIR=${CONF_PROVIDER_DIR:-./conf/provider}
if [ ! -d "$PROVIDER_DIR" ]; then
	echo "${PROVIDER_DIR} is not a valid directory accessible from your current location."
fi

for p in $(ls ${PROVIDER_DIR}/env.provider.*.sh 2> /dev/null);
do
	if [ -f ${p} ]; then
		echo "Sourcing ${p} parameters file..."
		source ${p}
	fi
done
