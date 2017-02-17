note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_ADD_MEDICINE_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent add_medicine(? , ? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as id and then attached {INTEGER_64} etf_cmd_args[2] as medicine and then attached {VALUE} etf_cmd_args[3] as dose
			then
				out := "add_medicine(" + etf_event_argument_out("add_medicine", "id", id) + "," + etf_event_argument_out("add_medicine", "medicine", medicine) + "," + etf_event_argument_out("add_medicine", "dose", dose) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	add_medicine_precond(id: INTEGER_64 ; medicine: INTEGER_64 ; dose: VALUE): BOOLEAN
		do  
			Result := 
				         comment ("ID_RX = INTEGER_64")
				and then comment ("ID_MN = INTEGER_64")
		ensure then  
			Result = 
				         comment ("ID_RX = INTEGER_64")
				and then comment ("ID_MN = INTEGER_64")
		end 
feature -- command 
	add_medicine(id: INTEGER_64 ; medicine: INTEGER_64 ; dose: VALUE)
		require 
			add_medicine_precond(id, medicine, dose)
    	deferred
    	end
end
