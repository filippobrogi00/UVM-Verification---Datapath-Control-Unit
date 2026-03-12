source /eda/scripts/init_design_vision

if [ -d work ]; then
	rm -rf work
fi
mkdir -p work
dc_shell-xg-t -f synthetize.tcl
