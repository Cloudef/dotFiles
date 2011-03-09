--[[
Ring Meters by londonali1010 (2009)

This script draws percentage meters as rings. It is fully customisable; all options are described in the script.

IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement on line 129 uses a delay to make sure that this doesn't happen. It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num>5 in that if statement (the default). If you only update Conky every 2s, you should change it to update_num>3; conversely if you update Conky every 0.5s, you should use update_num>10. ALSO, if you change your Conky, is it best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.

To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
    lua_load ~/scripts/rings.lua
    lua_draw_hook_pre ring_stats
]]

settings_table = {
    {
        -- Edit this table to customise your rings.
        -- You can create more rings simply by adding more elements to settings_table.
        -- "name" is the type of stat to display; you can choose from 'cpu', 'memperc', 'fs_used_perc', 'battery_used_perc'.
        name='time',
        -- "arg" is the argument to the stat type, e.g. if in Conky you would write ${cpu cpu0}, 'cpu0' would be the argument. If you would not use an argument in the Conky variable, use ''.
        arg='%H',
	-- "max" maximum value
	max=24,
        -- "bg_colour" is the colour of the base ring.
        bg_colour=0xCDCDC1,
        -- "bg_alpha" is the alpha value of the base ring.
        bg_alpha=0.5,
        -- "fg_colour" is the colour of the indicator part of the ring.
        fg_colour=0x1E90FF,
        -- "fg_alpha" is the alpha value of the indicator part of the ring.
        fg_alpha=0.8,
        -- "x" and "y" are the x and y coordinates of the centre of the ring, relative to the top left corner of the Conky window.
        x=120, y=120,
        -- "radius" is the radius of the ring.
        radius=81,
        -- "thickness" is the thickness of the ring, centred around the radius.
        thickness=10
    },
    {
        name='time',
        arg='%M',
	max=60,
        bg_colour=0xCDCDC1,
        bg_alpha=0.5,
        fg_colour=0x1E90FF,
        fg_alpha=0.8,
        x=120, y=120,
        radius=93,
        thickness=10
    },
    {
        name='time',
        arg='%S',
	max=60,
        bg_colour=0xCDCDC1,
        bg_alpha=0.2,
        fg_colour=0x1E90FF,
        fg_alpha=0.5,
        x=120, y=120,
        radius=102.5,
        thickness=5
    },
}
require 'cairo'

function rgb_to_r_g_b(colour,alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(t, pt)
    if conky_window == nil then return end
    local w, h = conky_window.width, conky_window.height
    local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual,w,h)
    
    cr=cairo_create(cs)
    
    local xc, yc, ring_r, ring_w = pt['x'], pt['y'], pt['radius'], pt['thickness']
    local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

    local t_arc=2*t*math.pi/(pt['max']-1)

    -- Draw background ring

    cairo_arc(cr,xc,yc,ring_r,0,2*math.pi)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
    cairo_set_line_width(cr,ring_w)
    cairo_stroke(cr)
    
    -- Draw indicator ring

    cairo_arc(cr,xc,yc,ring_r,0,t_arc)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
    cairo_stroke(cr)        
    
    cairo_destroy(cr)
    cr = nil
end

function conky_cairo_cleanup()
    cairo_surface_destroy(cs)
    cs = nil
end

function conky_ring_stats()
    local function parse_options(pt)
        local str=''
        local value=0
        
        str=string.format('${%s %s}',pt['name'],pt['arg'])
        if pcall(conky_parse,str) then
		str = conky_parse(str)
        else
		str='0'
        end
        
        value=tonumber(str)
        draw_ring(value, pt)
    end
    
    -- Check that Conky has been running for at least 5s
    
    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)
    
    if update_num>5 then
        for i in pairs(settings_table) do
            parse_options(settings_table[i])
        end
    end
end