function test_display_view() {
	local tasks_data=( $1 )
	local id=$2
	local expected="$3"
	local message="$4"

	actual=$( display_view "${tasks_data[*]}" $id )
	assert_expectation "${expected}" "${actual}" "$message"
}

function test_cases_display_view() {
	IFS=$'\n'
	echo -e "\nDisplay view"

	message="Should display status,description and tags of given id"
	tasks_data=( "1|pending|attend party|birthday" "2|done|play|cricket" )
	expected=$( cat expected_files/display_view.txt )
	test_display_view "${tasks_data[*]}" 1 "${expected}" "$message"

	message="Should display nothing when given id doesn't exist"
	tasks_data=( "2|pending|attend party|birthday" "3|done|play|cricket" )
	expected=""
	test_display_view "${tasks_data[*]}" 1 "${expected}" "$message"
}
