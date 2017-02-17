note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PRESCRIPTIONS_Q
inherit
	ETF_PRESCRIPTIONS_Q_INTERFACE
		redefine prescriptions_q end
create
	make
feature -- command
	prescriptions_q(medication_id: INTEGER_64)
		require else
			prescriptions_q_precond(medication_id)
    	do
    		model.set_output_mode(0)

    		if medication_id < 1 then
				model.set_message ("medication id must be a positive integer")
			elseif not(model.list_medication.has_key (medication_id)) then
				model.set_message ("medication id must be registered")
			else
				model.set_output_mode(2)
				model.set_message ("ok")
				model.prescriptions_q(medication_id)
			end

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
