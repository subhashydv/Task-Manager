function test_read_file_data() {
	local data=( $1 )
	local expected_array=( $2 )
	local message="$3"

	echo "${data[*]}" > read_data.txt
	local actual_array=( $( read_file_data "read_data.txt" ) )
	assert_expectation "${expected_array[*]}" "${actual_array[*]}" "${message}"
}

function test_cases_read_file_data() {
	local IFS=$'\n'
	echo -e "\nRead file data"

	local message="should return one array element when file contains single line"
	local data=( "session" )
	local expectation=( "session" )
	test_read_file_data "${data[*]}" "${expectation[*]}" "${message}"

	message="should return each line as an array element when file contains multiple lines"
	data=( "read book" "session" )
	expectation=( "read book" "session" )
	test_read_file_data "${data[*]}" "${expectation[*]}" "${message}"
}


function test_write_data_file() {
	local tasks_data=( $1 )
	local file_name="$2"
	local expected="$3"

	write_data_file "${tasks_data[*]}" "${file_name}"
	local actual=$( cat ${file_name} )

	assert_expectation "${expected}" "${actual}" "$message"
}

function test_cases_write_data_file () {
	local IFS=$'\n'
	echo -e "\nWrite data file"

	local message="should write first line in data file when array have single element"
	local expected=( hello )
	test_write_data_file "hello" "testing_files/write_data.txt" "${expected[*]}" "${message}"

	message="should write each array element in new line when array have multiple elements"
	tasks_data=( "1 3" "5 4 3" )
	expected=( "1 3" "5 4 3" )
	test_write_data_file "${tasks_data[*]}" "testing_files/write_data.txt" "${expected[*]}" "${message}"

	rm testing_files/write_data.txt
}
