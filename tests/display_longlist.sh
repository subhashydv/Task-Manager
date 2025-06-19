function test_convert_status_to_emoji () {
	local status="$1"
	local expected="$2"
	local message="$3"

	local actual=$( convert_status_to_emoji "${status}" )
	assert_expectation "${expected}" "${actual}" "${message}"
}

function test_cases_convert_status_to_emoji() {
	echo -e "\nConvert status to emoji"

	local message="Should convert status pending to ⌛️"
	test_convert_status_to_emoji "pending" "⌛️" "${message}"

	message="Should convert status done to ✔"
	test_convert_status_to_emoji "done" "✔" "${message}"

	message="Should not convert status other than pending and done"
	test_convert_status_to_emoji "do" "" "${message}"
}


function test_filter_tasks_by_tags() {
	local tasks_data=( $1 )
	local tags="$2"
	local expected="$3"
	local message="$4"

	actual=$( filter_tasks_by_tags "${tasks_data[*]}" "${tags}" )
	assert_expectation "${expected}" "${actual}" "$message"
}


function test_cases_filter_tasks_by_tags() {
	local IFS=$'\n'
	echo -e "\nFilter tasks by tag"

	message="Should return tasks which matches given tags"
	tasks_data=( "1|pending|work|fun,code" "2|pending|market|book" "3|pending|review|code" )
	expected=( "1|pending|work|fun,code" )
	test_filter_tasks_by_tags "${tasks_data[*]}" "code,fun" "${expected[*]}" "$message"

	message="Should not return anything when given tags doesn't match"
	tasks_data=( "1|pending|work|fun,code" "2|pending|market|" "3|pending|review|code" )
	expected=( "" )
	test_filter_tasks_by_tags "${tasks_data[*]}" "book" "${expected[*]}" "$message"

	message="Should return all tasks when tags are not provided"
	tasks_data=( "1|pending|work|fun,code" "2|pending|market|" )
	expected=( "1|pending|work|fun,code" "2|pending|market|" )
	test_filter_tasks_by_tags "${tasks_data[*]}" "" "${expected[*]}" "$message"
}


function test_display_longlist() {
	local tasks_data=( $1 )
	local tags="$2"
	local expected="$3"
	local message="$4"

	local actual=$( display_longlist "${tasks_data[*]}" )
	assert_expectation "${expected}" "${actual}" "${message}"
}

function test_cases_display_longlist() {
	local IFS=$'\n'
	echo -e "\nDisplay longlist"

	local message="Should display tasks along with their id,status and tags"
	local tasks_data=( "1|pending|read|news" "2|done|session|meet"  )
	local expected=$( cat expected_files/longlist_task.txt )
	test_display_longlist "${tasks_data[*]}" "" "${expected}" "${message}"

	message="Should filter tasks by given list of tags"
	tasks_data=( "1|pending|read|news" "2|done|session|meet,news" "3|done|session|"  )
	expected=$( cat expected_files/longlist_filter_tag.txt )
	test_display_longlist "${tasks_data[*]}" "tags:news" "${expected}" "${message}"

	message="Should display header if data is not provided"
	expected=( "id  status  description  tags" "--  ------  -----------  ----" )
	test_display_longlist "" "" "${expected[*]}" "${message}"
}
