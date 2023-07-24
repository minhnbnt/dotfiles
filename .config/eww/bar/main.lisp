(defwindow bar
	:exclusive true
	:monitor 0
	:windowtype "dock"
	:stacking "overlay"
	:focusable false
	:geometry (geometry :x "5px"
	                    :height "758px"
	                    :anchor "left center")
	:reserve (struts :side "left" :distance "4%")
	(box :orientation "v"
	     :class "bar"
		(box :orientation "v"
		     :space-evenly false
			(launcher)
			(workspaces))
		(box :orientation "v"
		     :valign "end"
		     :space-evenly false
			(box :class "container"
			     :orientation "v"
			     :space-evenly false
				(network)
				(battery)
				(bri-slider)
				(vol-slider))
			(clock)
			(power-buttons))))

(defwidget launcher []
	(button :class "launcher"
	        :tooltip "App launcher"
	        :onclick "wofi -f -S run" ""))

(deflisten workspace "python3 ~/.config/eww/bar/src/workspace.py")
(defwidget workspaces [] (literal :content workspace))

(defpoll network :interval "30s" "~/.config/eww/bar/bin/network")
(defwidget network []
	(box :tooltip { network["tooltip"] }
	     :class { network["class"] }
	     { network["icon"] }))

(defpoll battery :interval "30s" "~/.config/eww/bar/bin/battery")
(defwidget battery []
	(box :class "bat-icon"
	     :tooltip { battery["tooltip"] }
		(label :markup { battery["icon"] })))

(defvar brightness-active false)
(defpoll brightness :interval "1s" "xbacklight -get")
(defwidget bri-slider []
	(eventbox :onhover "eww update brightness-active=true"
	          :onhoverlost "eww update brightness-active=false"
		(box :orientation "v"
		     :class "brightness-slider"
		     :space-evenly false
			(revealer :transition "slideup"
			          :reveal brightness-active
			          :duration "550ms"
				(metric :class "bri-slider"
				        :value brightness
				        :onchange "xbacklight -set {}"))
			(box :tooltip "Brightness: ${brightness}%"
			     :class "bri-icon" ""))))

(defvar volume-active false)
(defpoll volume :interval "1s" "~/.config/eww/bar/bin/volume")
(defwidget vol-slider []
	(eventbox :onhover "eww update volume-active=true"
	          :onhoverlost "eww update volume-active=false"
		(box :orientation "v"
		     :class "volume-slider"
		     :space-evenly false
			(revealer :transition "slideup"
			          :reveal { volume-active && !volume["muted"] }
			          :duration "550ms"
				(metric :class "vol-slider"
				        :value { volume["vol"] }
				        :onchange "pamixer --set-volume {}"))
			(button :onclick "pamixer -t"
			        :tooltip { volume["tooltip"] }
			        :class "vol-icon" { volume["icon"] }))))

(defvar date-visible false)
(defpoll date :run-while date-visible
              :interval "1s" "date '+%a, %d %b %Y %H:%M:%S'")
(defpoll cal :interval "1s" "~/.config/eww/bar/bin/calendar")
(defwidget clock []
	(eventbox :onhover "eww update date-visible=true"
			  :onhoverlost "eww update date-visible=false"
		(box :class "clock"
			 :orientation "v"
			 :space-evenly false
			 :tooltip "${date}"
			 (box { cal["hour"] })
			 (box { cal["minute"] })
			 (box { cal["second"] }))))

(defwidget metric [value onchange class]
	(box :orientation "v"
	     :class class
	     :halign "center"
		(scale :min 0
			   :max 101
			   :orientation "v"
			   :active { onchange != "" }
			   :flipped true
			   :value value
			   :onchange onchange)))

(defvar powermenu false)
(defwidget power-buttons []
	(eventbox :onhover "eww update powermenu=true"
	          :onhoverlost "eww update powermenu=false"
		(box :orientation "v"
			 :space-evenly false
			 :class "container"
			(revealer :transition "slideup"
					  :reveal powermenu
					  :duration "550ms"
				(box :orientation "v"
					 :space-evenly false
					(button :class "button-sus" ; amogus
							:tooltip "Suspend"
							:onclick "systemctl suspend" "")
					(button :class "button-exit"
							:tooltip "Exit"
							:onclick "hyprctl dispatch exit --" "")
					(button :class "button-res"
							:tooltip "Restart"
							:onclick "shutdown -r now" "")))
			(button :class { powermenu ? "button-pow-alt" : "button-pow" }
					:tooltip "Shutdown"
					:onclick "shutdown -P now" ""))))
