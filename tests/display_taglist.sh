function test_get_unique_tags() {
	local tasks_data=( $1 )
	local expected="$2"
	local message="$3"

	local actual=$( get_unique_tags "${tasks_data[*]}" )

	assert_expectation "${expected}" "${actual}" "${message}"
}

function test_cases_get_unique_tags() {
	local IFS=$'\n'
	echo -e "\nGet unique tags"

	local message="Should display unique tags in sorted order"
	local tasks_data=( "fun" "birthday" "fun,birthday,party" )
	local expected=( "birthday" "fun" "party" )
	test_get_unique_tags "${tasks_data[*]}" "${expected[*]}" "${message}"
}

function test_display_taglist() {
	local tasks_data=( $1 )
	local expected="$2"
	local message="$3"

	local actual=$( display_taglist "${tasks_data[*]}" )
	assert_expectation "${expected}" "${actual}" "${message}"
}


function test_cases_display_taglist() {
	local IFS=$'\n'
	echo -e "\nDisplay taglist"

	message="Should list all the tags with task-id"
	tasks_data=( "1|pending|go to market|book" "2|pending|attend to party|fun" )
	expected=( "tag   task-ids" "---   --------" "book  1" "fun   2" )
	test_display_taglist "${tasks_data[*]}" "${expected[*]}" "${message}"

	message="Should list all the tags with task-ids when multiple tasks have common tags"
	tasks_data=( "1|pending|go to market|book" "2|pending|attend to party|book" )
	expected=( "tag   task-ids" "---   --------" "book  1,2" )
	test_display_taglist "${tasks_data[*]}" "${expected[*]}" "${message}"

	message="Should display header when data is not provided"
	tasks_data=()
	expected=( "tag  task-ids" "---  --------" )
	test_display_taglist "${tasks_data[*]}" "${expected[*]}" "${message}"
}
