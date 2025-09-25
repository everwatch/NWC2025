ENVtest1="MySQL Check: myDatabase performance"
ENVtest2="Disk Usage on / 80 90"
ENVtest3="One Two: Three - Four 5 6"

test:	test-env test-napi

test-env:	ENV
	@echo "### This should give $(ENVtest1)"
	@NAGIOS_TEST=$(ENVtest1) ./ENV -n test
	@echo ""
	@echo "### This should give / then 80 then 90 then |"
	NAGIOS_TEST=$(ENVtest2) ./ENV -n test -F 1
	NAGIOS_TEST=$(ENVtest2) ./ENV -n test -F 2
	NAGIOS_TEST=$(ENVtest2) ./ENV -n test -F 3
	NAGIOS_TEST=$(ENVtest2) ./ENV -n test -F 1 -p
	@echo ""
	@echo "### This should give Check, then myDatabase, then myDatabase performance, then MySQL Check"
	NAGIOS_TEST=$(ENVtest1) ./ENV -n test -f 2
	NAGIOS_TEST=$(ENVtest1) ./ENV -n test -f 4
	NAGIOS_TEST=$(ENVtest1) ./ENV -n test -d : -f 2
	NAGIOS_TEST=$(ENVtest1) ./ENV -n test -d : -f -2
	@echo ""
	@echo "### This should give Password"
	NAGIOS_TEST=$(ENVtest1) NAGIOS__HOSTMYDATABASEPASS=Password ./ENV -n test -f -2 -HT pass
	@echo ""
	@echo "### Test string is: $(ENVtest3)"
	@echo "### The first test should be the full test line, then blank line, then number 5, then FourToken twice"
	NAGIOS_TEST=$(ENVtest3) ./ENV -n TeSt
	NAGIOS_TEST=$(ENVtest3) ./ENV -n TEST -F 2 -S 5
	NAGIOS_TEST=$(ENVtest3) ./ENV -n test -F 2 --num
	NAGIOS_TEST=$(ENVtest3) NAGIOS__HOSTFOURTOKEN="FourToken" ./ENV -H -n fourtoken
	NAGIOS_TEST=$(ENVtest3) NAGIOS__HOSTFOURTOKEN="FourToken" ./ENV -n test -F 1 -HT TOKEN
	@echo ""
	@echo "### This should return Level2"
	NAGIOS__HOSTNCPAPASS="Level2" ./ENV set.txt -n asdf -T NCPAPASS
	@echo ""
	@echo "### This should return Balloons, 91, Red"
	NAGIOS_TEST="HTTP -S 8099" ./ENV set.txt -n TEST  -g "8.*" -d 0 -f 2 --pre "Balloons, " --post ", Red"

test-napi:
	echo ""; echo "Testing --status"
	./napi --ace 1 --status | csvtool readable - | head
	echo ""; echo "Testing --bstatus"
	./napi --ace 1 --bstatus | csvtool readable - | head
	echo ""; echo "Testing --hstatus"
	./napi --ace 1 --hstatus | csvtool readable - | head
	echo ""; echo "Testing --bhstatus"
	./napi --ace 1 --bhstatus | csvtool readable - | head
	echo ""; echo "Testing localhost"
	./napi -h localhost -s Active -q
