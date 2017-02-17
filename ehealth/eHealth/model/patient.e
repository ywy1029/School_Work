note
	description: "Summary description for {PATIENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PATIENT

inherit
	SORTABLE
	redefine out end

create
	make

feature
	make(a_id: INTEGER_64; a_name: STRING)
		do
			id := a_id
			pati_name := a_name
		end

feature
	pati_name: STRING

feature
	out : STRING
		do
			create Result.make_from_string ("")
			Result.append (id.out + "->"+ pati_name)
		end

end
