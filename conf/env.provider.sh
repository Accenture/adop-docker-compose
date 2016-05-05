# Environment file which sources other provider-specific environment files

echo "Sourcing provider-specific environment files..."

for p in $(ls ${CONF_PROVIDER_DIR}/env.provider.*.sh 2> /dev/null);
do
	if [ -f ${p} ]; then
		echo "Sourcing ${p} parameters file..."
		source ${p}
	fi
done
