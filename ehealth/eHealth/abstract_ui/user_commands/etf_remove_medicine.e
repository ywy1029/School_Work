note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REMOVE_MEDICINE
inherit
	ETF_REMOVE_MEDICINE_INTERFACE
		redefine remove_medicine end
create
	make
feature -- command
	remove_medicine(id: INTEGER_64 ; medicine: INTEGER_64)
		require else
			remove_medicine_precond(id, medicine)
    	do
    		model.set_output_mode(0)

			if id < 1 then
				model.set_message ("prescription id must be a positive integer")
			elseif not model.list_prescription.has_key (id) then
				model.set_message ("prescription with this id does not exist")
			elseif medicine < 1 then
				model.set_message ("medication id must be a positive integer")
			elseif not model.list_medication.has (medicine)  then
				model.set_message ("medication id must be registered")
			elseif not model.is_medcine_in_prescription (id, medicine) then
				model.set_message ("medication is not in the prescription")
			else
				model.set_message ("ok")
				model.remove_medicine (id, medicine)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
