function test_include_task() {
	local tasks_data=( $1 )
	local task="$2"
	local tags="$3"
	local expected=( $4 )
	local message="$5"

	local actual=( $( include_task "${tasks_data[*]}" "${task}" "${tags}" ) )
	assert_expectation "${expected[*]}" "${actual[*]}" "$message"
}

function test_cases_include_task() {
	local IFS=$'\n'
	echo -e "\nInclude task"

	local message="Should add the first task when last id is none"
	local expected=( 1 "1|pending|play|fun" )
	test_include_task 0 "play" "fun" "${expected[*]}" "$message"

	message="Should add the second task when last id is 1"
	local tasks_data=( 1 "1|pending|attend party|" )
	expected=( 2 "1|pending|attend party|" "2|pending|go to market|pen" )
	test_include_task "${tasks_data[*]}" "go to market" "pen" "${expected[*]}" "$message"
}

function test_add_task() {
	local tasks_data=( $1 )
	local task="$2"
	local file_name="$3"
	local tags="$4"
	local expected="$5"
	local message="$6"

	local actual=$( add_task "${tasks_data[*]}" "${task}" "${file_name}" "${tags}" )
	assert_expectation "${expected}" "${actual}" "${message}"
}

function test_cases_add_task() {
	local IFS=$'\n'
	echo -e "\nAdd task"

	local message="Should create first task when prior created id is none"
	test_add_task 0 "play" "test_file.txt" "tags:chess" "Created task 1" "${message}"

	message="Should create second task when prior created id is 1"
	local tasks_data=( 1 "1|pending|read" )
	test_add_task "${tasks_data[*]}" "write" "test_file.txt" "tags:novel" "Created task 2" "${message}"

	message="Should create second task when prior created id is 1 and that task doesn't exist"
	test_add_task 1 "drive bike" "test_file.txt" "tags:license" "Created task 2" "${message}"

	rm test_file.txt
}

function test_get_tag_data() {
	local tags="$1"
	local expected="$2"
	local message="$3"

	local actual=$( get_tag_data "${tags}" )
	assert_expectation "${expected}" "${actual}" "${message}"
}

function test_cases_get_tag_data() {
	echo -e "\nGet tag data"

	local message="Should return tag data when \"tags\" is specified"
	test_get_tag_data "tags:fun" "fun" "${message}"

	message="Should not return tag data when \"tags\" is not specified"
	test_get_tag_data "fun" "" "${message}"
}
