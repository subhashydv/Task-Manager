function test_main() {
	local data_file="$1"
	local subcommand="$2"
	local user_data="$3"
	local expected="$4"
	local message="$5"

	cp "${data_file}" tmp_file.txt 2> /dev/null
	local actual=$( main "tmp_file.txt" "${subcommand}" "${user_data}" )

	assert_expectation "${expected}" "${actual}" "${message}"
	rm tmp_file.txt 2> /dev/null
}


function test_cases_main() {
	local IFS=$'\n'
	echo -e "\nMain"

	local message="Should add task when subcommand is add"
	test_main "testing_files/main_add.txt" "add" "play" "Created task 1" "${message}"

	message="Should mark task as done when subcommand is done"
	test_main "testing_files/main_done.txt" "done" 1 "marked task 1 play as done" "${message}"

	message="Should delete task when subcommand is delete"
	test_main "testing_files/main_delete.txt" "delete" 1 "deleted task 1 session" "${message}"

	echo

	message="Should list pending tasks when subcommand is list"
	local expectation=( "id  description  tags" "--  -----------  ----" )
	test_main "testing_files/main_list.txt" "list" "" "${expectation[*]}" "${message}"

	message="Should list all tasks with status when subcommand is longlist"
	expectation=( "id  status  description  tags" "--  ------  -----------  ----" )
	test_main "testing_files/main_list.txt" "longlist" "" "${expectation[*]}" "${message}"

	message="Should list status,description and tags of given id when subcommand is view"
	expected=$( cat expected_files/display_view.txt )
	test_main "testing_files/main_view.txt" "view" 1 "${expected}" "${message}"

	message="Should list tags with task-ids when subcommand is taglist"
	expected=( "tag  task-ids" "---  --------" )
	test_main "testing_files/main_taglist.txt" "taglist" "" "${expected[*]}" "${message}"

	message="Should show task manager usage when subcommand is help"
	expectation=$( cat expected_files/help.txt )
	test_main "" "help" "" "${expectation}" "${message}"

	message="Should show task manager usage when subcommand not found"
	expectation=$( cat expected_files/help.txt )
	test_main "" "hel" "" "${expectation}" "${message}"
}

