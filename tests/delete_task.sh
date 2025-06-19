function test_unset_index() {
	local data=( $1 )
	local id=$2
	local expected=( $3 )
	local message="$4"

	local actual=( $( unset_index "${data[*]}" "${id}" ) )
	assert_expectation "${expected[*]}" "${actual[*]}" "${message}"
}

function test_cases_unset_index() {
	local IFS=$'\n'
	echo -e "\nUnset index"

	local message="Should unset first element of array when given index is 0"
	local data=( 1 4 )
	local expected=( 4 )
	test_unset_index "${data[*]}" 0 "${expected[*]}" "${message}"

	message="Should unset second element of array when given index is 1"
	data=( 2 3 4 )
	expected=( 2 4 )
	test_unset_index "${data[*]}" 1 "${expected[*]}" "${message}"
}


function test_delete_task() {
	local tasks_data=( $1 )
	local id=$2
	local file_name="$3"
	local expected="$4"
	local message="$5"

	local actual=$( delete_task "${tasks_data[*]}" "${id}" "${file_name}" )
	assert_expectation "${expected}" "${actual}" "${message}"
}

function test_cases_delete_task() {
	local IFS=$'\n'
	echo -e "\nDelete task"

	local message="Should delete first task when given id is 1"
	local tasks_data=( 1 "1|pending|play" )
	test_delete_task "${tasks_data[*]}" 1 "testing_file.csv" "deleted task 1 play" "${message}"

	message="Should not delete task when given id doesn't exist"
	tasks_data=( 2 "1|pending|play" "2|done|pay" )
	test_delete_task "${tasks_data[*]}" 3 "testing_file.csv" "" "${message}"
	rm testing_file.csv
}
