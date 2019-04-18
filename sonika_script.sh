#!/bin/bash

. ./shrc

#from stack overflow
while IFS=' ' read -r line || [[ -n "$line" ]]; do
	echo "Running test: $line"
	runspec --fake --loose --size test --tune base --config Sonika-linux64-ia32-gcc43+.cfg $line
	cd /home/sonika/Downloads/SPEC_CPU2006/SPEC_CPU2006v1.2/benchspec/CPU2006/$line/build/build_base_gcc43-32bit.0000/
	specmake -clean 
	specmake  
        test_name="$(cut -d'.' -f2 <<< "$line")"
	echo "$line"
	echo "$test_name"
	if [ "$test_name" = "sphinx3" ] 
	then
		echo "hello"
		test_name=${test_name/sphinx3/sphinx_livepretend} 
	fi
   	cp $test_name /home/sonika/Documents/build_without/$test_name
	/home/sonika/Documents/llvm-prefix/bin/opt -load /home/sonika/Documents/llvm-pass-dfsan/mutable-pass/build/mutable/libMutablePass.so -mutable $test_name.0.5.precodegen.bc -o $test_name.0.5.precodegen.inst.bc 
	/home/sonika/Documents/llvm-prefix/bin/clang $test_name.0.5.precodegen.inst.bc -o $test_name.inst.out -lm
	cp $test_name.inst.out /home/sonika/Documents/build_with/$test_name
done < "$1"

#cd /home/sonika/Downloads/SPEC_CPU2006/SPEC_CPU2006v1.2/benchspec/CPU2006/$line/build/build_base_gcc43-32bit.0000/

