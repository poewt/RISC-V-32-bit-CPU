import os
import sys
import platform

is_windows = platform.system() == "Windows";

print(is_windows)

if len(sys.argv) < 2:
    print("Missing module name")
    sys.exit(1)

mod_name = sys.argv[1]
print(mod_name)

if is_windows:
    os.system(f"iverilog -o {mod_name}_tb {mod_name}.v {mod_name}_tb.v ; vvp {mod_name}_tb ; gtkwave {mod_name}_tb.vcd")
else:
    os.system(f"iverilog -o {mod_name}_tb {mod_name}.v {mod_name}_tb.v && vvp {mod_name}_tb && gtkwave {mod_name}_tb.vcd")