
local counter = {} -- playername -> count

missions.register_step({

	type = "simpledig",
	name = "Dig any nodes",

	create = function()
		return {count=100}
	end,

	get_status = function(ctx)
		local player = ctx.player

		local name = player:get_player_name()
		local current_count = counter[name] or 0
		local rest = stepdata.count - (current_count - stepdata.start)
		return "Dig " .. rest .. " nodes"
	end,

	edit_formspec = function(ctx)
		local stepdata = ctx.step.data

		local formspec = "size[8,8;]" ..
			"label[0,0;Dig any nodes]" ..
	
			"field[0,2;8,1;count;Count;" .. stepdata.count ..  "]" ..
			"button_exit[0,7;8,1;save;Save]"

		return formspec;
	end,

	update = function(ctx)
		local fields = ctx.fields
		local stepdata = ctx.step.data

		if fields.count then
			local count = tonumber(fields.count)
			if count and count > 0 then
				stepdata.count = count
			end
		end

		if fields.save then
			ctx.show_mission()
		end
	end,

	on_step_enter = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data

		local name = player:get_player_name()
		stepdata.start = counter[name] or 0
	end,

	on_step_interval = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data

		local name = player:get_player_name()
		local current_count = counter[name] or 0
		if current_count - stepdata.start >= stepdata.count then
			ctx.on_success()
		end
	end,

	on_step_exit = function(ctx)
	end


})

minetest.register_on_dignode(function(pos, oldnode, digger)
	if digger ~= nil and digger:is_player() then
		local name = digger:get_player_name()
		local count = counter[name]
		if not count then
			count = 0
		end

		count = count + 1
		counter[name] = count
	end
end)


