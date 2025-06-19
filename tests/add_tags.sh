function test_append_tags() {
	local data=( $1 )
	local tags="$2"
	local index=$3
	local expected="$4"
	local message="$5"

	local actual=$( append_tags "${data[*]}" "${tags}" ${index} )

	assert_expectation "${expected}" "${actual}" "${message}"
}

function test_cases_append_tags() {
	local IFS=$'\n'
	echo -e "\nAppend tags"

	local message="Should add tags when tags in given id doesn't exist"
	local data=( "1|pending|session|" "2|done|session|")
	local expected=( "1|pending|session|birthday,fun" "2|done|session|" )
	test_append_tags "${data[*]}" "birthday,fun" 0 "${expected[*]}" "${message}"

	message="Should add tags when given id already has tags"
	data=( "1|pending|session|book" "2|done|session|")
	expected=( "1|pending|session|book,fun" "2|done|session|")
	test_append_tags "${data[*]}" "fun" 0 "${expected[*]}" "${message}"
}

function test_add_tags() {
	local data=( $1 )
	local id=$2
	local tags="$3"
	local data_file="$4"
	local expected="$5"
	local message="$6"

	local actual=$( add_tags "${data[*]}" $id "$tags" "${data_file}" )

	assert_expectation "${expected}" "${actual}" "${message}"
}

function test_cases_add_tags() {
	local IFS=$'\n'
	echo -e "\nAdd tags"

	local message="Should display message when task has been tagged with given tag"
	local data=( 1 "1|pending|party|" )
	local expected="task 1 has been tagged with birthday."
	test_add_tags "${data[*]}" 1 "tags:birthday" "tags.txt" "${expected}" "${message}"

	message="Should display message when task has been tagged with multiple tags"
	data=( 2 "1|pending|party|" "2|pending|plan an event|fun" )
	expected="task 2 has been tagged with birthday and cake."
	test_add_tags "${data[*]}" 2 "tags:birthday,cake" "tags.txt" "${expected}" "${message}"

	message="Should not display message when id is invalid"
	data=( 2 "1|pending|party|" "2|pending|plan an event|" )
	expected=""
	test_add_tags "${data[*]}" 3 "tags:birthday" "tags.txt" "${expected}" "${message}"

	message="Should not display message when \"tags\" is not specified"
	data=( 2 "1|pending|party|" "2|pending|plan an event|" )
	expected=""
	test_add_tags "${data[*]}" 2 "tag:birthday" "tags.txt" "${expected}" "${message}"

	rm tags.txt
}
