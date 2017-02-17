note
	description: "Summary description for {PRESCRIPTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRESCRIPTION

inherit
	SORTABLE
	redefine out end

create
	make

feature
	make(a_id: INTEGER_64 ; doctor: INTEGER_64 ; patient: INTEGER_64)
		do
			id := a_id
			doctor_id := doctor
			patient_id := patient

			create list_medicine.make (10)
		end

feature
	doctor_id : INTEGER_64
	patient_id : INTEGER_64

	list_medicine: ARRAYED_LIST[TUPLE[m_id: INTEGER_64; dose: VALUE]]

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("")
			Result.append (id.out + "->[" + id.out + "," + doctor_id.out + "," + patient_id.out + ",(")
			from
				list_medicine.start
			until
				list_medicine.after
			loop
				Result.append(list_medicine.item_for_iteration.m_id.out + "->" + list_medicine.item_for_iteration.dose.out)
				if not list_medicine.islast then
					Result.append(",")
				end
				list_medicine.forth
			end
			Result.append (")]")
		end

	has_medicine(medi_id: INTEGER_64) : BOOLEAN
		do
			Result := false

			from
				list_medicine.start
			until
				list_medicine.after or Result = true
			loop
				if list_medicine.item_for_iteration.m_id = medi_id then
					Result := true
				end
				list_medicine.forth
			end
		end

end
