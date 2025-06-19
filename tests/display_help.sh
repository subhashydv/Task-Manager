function test_display_help() {
	local expected="$1"
	local message="$2"

	local actual=$( display_help )
	assert_expectation "${expected}" "${actual}" "${message}"
}


function test_cases_display_help() {
	echo -e "\nDisplay help"

	local expectation=$( cat expected_files/help.txt )

	local message="Should show task manager usage"
	test_display_help "${expectation}" "${message}"
}
