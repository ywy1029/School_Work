note
	description: "Summary description for {DPR_Q_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPR_Q_ITEM

inherit
	COMPARABLE
	redefine is_less,out end

create
	make

feature
	make(a_id: INTEGER_64; a_name: STRING)
		do
			pati_id := a_id
			pati_name := a_name
			create dpr_q_interaction.make (10)
		end

feature
	pati_id: INTEGER_64
	pati_name: STRING
	dpr_q_interaction: ARRAYED_LIST[TUPLE[a:INTEGER_64; b:INTEGER_64]]

feature --opration
	add_dangerous_interaction(a_interaction: TUPLE[a:INTEGER_64; b:INTEGER_64])
		do
			dpr_q_interaction.extend (a_interaction)
		end

feature --query
	out : STRING
		do
			create Result.make_from_string ("")
		end

	out_dpr_item(list_medication: HASH_TABLE[MEDICATION,INTEGER_64]) : STRING
		do
			create Result.make_from_string ("")
			Result.append ("(" + pati_name + "," + pati_id.out + ")")
			Result.append ("->{ ")
			from
				dpr_q_interaction.start
			until
				dpr_q_interaction.after
			loop
				if attached list_medication.at (dpr_q_interaction.item_for_iteration.a) as medi_a and
				attached list_medication.at (dpr_q_interaction.item_for_iteration.b) as medi_b then
					Result.append("[" + medi_a.medicine.name + "," + medi_a.get_kind + "," + medi_a.id.out + "]")
					Result.append("->")
					Result.append("[" + medi_b.medicine.name + "," + medi_b.get_kind + "," + medi_b.id.out + "]")
				end

				if not dpr_q_interaction.islast then
					Result.append(", ")
				end
				dpr_q_interaction.forth
			end
			Result.append (" }")
		end

feature --compare

	is_less alias "<" (other: like current): BOOLEAN
		do
			if pati_name < other.pati_name then
				Result := true
			elseif pati_name > other.pati_name then
				Result := false
			else
				if pati_id < other.pati_id then
					Result := true
				else
					Result := false
				end
			end
		end

end

