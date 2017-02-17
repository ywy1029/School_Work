note
	description: "Summary description for {PHYSICIAN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PHYSICIAN

inherit
	SORTABLE
	redefine out end

create
	make

feature
	make(a_id: INTEGER_64; a_name: STRING; a_type: INTEGER_64)
		do
			id := a_id
			phys_name := a_name
			phys_type := a_type
		end

feature
	phys_type : INTEGER_64
	phys_name : STRING

feature -- queries
	out : STRING
		local
			type_str : STRING
		do
			if phys_type = 3 then
				type_str := "gn"
			elseif phys_type = 4 then
				type_str := "sp"
			else
				type_str := "unknown"
			end
			create Result.make_from_string ("")
			Result.append (id.out + "->[" + phys_name + "," + type_str + "]")
		end

end
