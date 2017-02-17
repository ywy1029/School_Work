note
	description: "Summary description for {MEDICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MEDICATION

inherit
	SORTABLE
	redefine out end

create
	make

feature
	make(a_id: INTEGER_64 ; a_medicine: TUPLE[name: STRING; kind: INTEGER_64; low: VALUE; hi: VALUE])
		do
			id := a_id
			medicine := a_medicine
		end

feature
	medicine : TUPLE[name: STRING; kind: INTEGER_64; low: VALUE; hi: VALUE]

feature -- queries
	out : STRING
		local
			type_str : STRING
		do
			if medicine.kind = 1 then
				type_str := "pl"
			elseif medicine.kind = 2 then
				type_str := "lq"
			else
				type_str := "unknown"
			end
			create Result.make_from_string ("")
			Result.append (id.out + "->[" + medicine.name + "," + type_str + "," + medicine.low.out + "," + medicine.hi.out + "]")
		end

	get_kind : STRING
		do
			create Result.make_from_string ("")
			if medicine.kind = 1 then
				Result.append ("pl")
			elseif medicine.kind = 2 then
				Result.append ("lq")
			else
				Result.append ("unknown")
			end
		end

end
