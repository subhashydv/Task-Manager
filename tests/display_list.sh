function test_display_list() {
	local tasks_data=( $1 )
	local expected="$2"

	local actual=$( display_list "${tasks_data[*]}" )
	assert_expectation "${expected}" "${actual}" "${message}"
}

function test_cases_display_list() {
	local IFS=$'\n'
	echo -e "\nDisplay list"

	local message="Should display pending tasks along with their ids and tags"
	tasks_data=( "1|pending|read books|sci-fi,comedy"  )
	expected=( "id  description  tags" "--  -----------  ----" "1.  read books   [comedy sci-fi]" )
	test_display_list "${tasks_data[*]}" "${expected[*]}"

	message="Should display header if data is not provided"
	tasks_data=()
	expected=( "id  description  tags" "--  -----------  ----" )
	test_display_list "${tasks_data[*]}" "${expected[*]}"
}

test_sort_tags() {
	local tags="$1"
	local expected="$2"
	local message="$3"

	local actual=$( sort_tags "$tags" )
	assert_expectation "${expected}" "${actual}" "${message}"
}


function test_cases_sort_tags() {
	echo -e "\nSort tags"

	message="Should sort given tags in alphabatical order"
	test_sort_tags "fun,birthday" "birthday fun" "${message}"

	message="Should sort given tags in numerical order"
	test_sort_tags "1,10,2" "1 2 10" "${message}"

	message="Should seperate sorted tags with blank spaces"
	test_sort_tags "birthday,fun" "birthday fun" "${message}"
}
