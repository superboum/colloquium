module DateFunction
	def self.check_date_format(params,d)
		begin
			params[d] = Date.parse(params[d]).strftime("%d/%m/%Y")
		rescue
			params["errors"][d]="Wrong date format"
		end 
	end

end