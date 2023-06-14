OverdoneServers.Materials = OverdoneServers.Materials or {}

local SVG = OverdoneServers:GetLibrary("svg_loader")

local mats = {
    ["Arrow:Glow"] = [[
        <svg width="228" height="227" viewBox="0 0 228 227" fill="none" xmlns="http://www.w3.org/2000/svg">
        	<g filter="url(#filter0_f)">
        		<path d="M94.3298 38.1362L114.47 18L209.635 113.149L189.495 133.285L94.3298 38.1362Z" fill="white"/>
        		<path d="M189.86 93.7148L210 113.851L114.834 209L94.6946 188.864L189.86 93.7148Z" fill="white"/>
        		<path d="M18 130.388V97.7156H171.389V130.388H18Z" fill="white"/>
        	</g>
        	<path d="M94.3298 38.1362L114.47 18L209.635 113.149L189.495 133.285L94.3298 38.1362Z" fill="white"/>
        	<path d="M189.86 93.7148L210 113.851L114.834 209L94.6946 188.864L189.86 93.7148Z" fill="white"/>
        	<path d="M18 130.388V97.7156H171.389V130.388H18Z" fill="white"/>
        	<defs>
        		<filter id="filter0_f" x="0" y="0" width="228" height="227" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
        			<feFlood flood-opacity="0" result="BackgroundImageFix"/>
        			<feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
        			<feGaussianBlur stdDeviation="9" result="effect1_foregroundBlur"/>
        		</filter>
        	</defs>
        </svg>
    ]],

    ["UBox:Glow"] = [[
        <svg width="286" height="302" viewBox="0 0 286 302" fill="none" xmlns="http://www.w3.org/2000/svg">
        	<path d="M18 18H268V38H18V18Z" fill="white"/>
        	<path d="M18 264H268V284H18V264Z" fill="white"/>
        	<path d="M18 18H38V284H18V18Z" fill="white"/>
        	<g filter="url(#filter0_f)">
        		<path d="M18 18H268V38H18V18Z" fill="white"/>
        		<path d="M18 264H268V284H18V264Z" fill="white"/>
        		<path d="M18 18H38V284H18V18Z" fill="white"/>
        	</g>
        	<defs>
        		<filter id="filter0_f" x="0" y="0" width="286" height="302" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
        			<feFlood flood-opacity="0" result="BackgroundImageFix"/>
        			<feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
        			<feGaussianBlur stdDeviation="9" result="effect1_foregroundBlur"/>
        		</filter>
        	</defs>
        </svg>
    ]],

    ["Gear:Glow"] = [[
        <svg width="1546" height="1552" viewBox="0 0 1546 1552" fill="none" xmlns="http://www.w3.org/2000/svg">
        	<g filter="url(#filter0_f)">
        		<circle cx="772.5" cy="775.5" r="554.5" fill="white"/>
        		<circle cx="772.5" cy="775.5" r="437" fill="white" stroke="#B3B3B3" stroke-width="75"/>
        		<path d="M922.832 169.134L1096.35 241.009L1110.91 336.525L845 226.381L922.832 169.134Z" fill="white"/>
        		<path d="M447.194 241.01L620.716 169.134L698.549 226.381L432.638 336.525L447.194 241.01Z" fill="white"/>
        		<path d="M621.717 1382.39L448.195 1310.52L433.638 1215L699.549 1325.14L621.717 1382.39Z" fill="white"/>
        		<path d="M1098.36 1306.52L924.833 1378.39L847 1321.14L1112.91 1211L1098.36 1306.52Z" fill="white"/>
        		<path d="M1304.52 450.194L1376.39 623.716L1319.14 701.549L1209 435.638L1304.52 450.194Z" fill="white"/>
        		<path d="M1376.39 925.832L1304.52 1099.35L1209 1113.91L1319.14 848L1376.39 925.832Z" fill="white"/>
        		<path d="M241.01 1099.36L169.135 925.833L226.381 848L336.525 1113.91L241.01 1099.36Z" fill="white"/>
        		<path d="M169.134 623.717L241.009 450.195L336.525 435.638L226.381 701.549L169.134 623.717Z" fill="white"/>
        	</g>
        	<circle cx="772.5" cy="775.5" r="554.5" fill="white"/>
        	<circle cx="772.5" cy="775.5" r="437" fill="white" stroke="#B3B3B3" stroke-width="75"/>
        	<path d="M922.832 169.134L1096.35 241.009L1110.91 336.525L845 226.381L922.832 169.134Z" fill="white"/>
        	<path d="M447.194 241.01L620.716 169.134L698.549 226.381L432.638 336.525L447.194 241.01Z" fill="white"/>
        	<path d="M621.717 1382.39L448.195 1310.52L433.638 1215L699.549 1325.14L621.717 1382.39Z" fill="white"/>
        	<path d="M1098.36 1306.52L924.833 1378.39L847 1321.14L1112.91 1211L1098.36 1306.52Z" fill="white"/>
        	<path d="M1304.52 450.194L1376.39 623.716L1319.14 701.549L1209 435.638L1304.52 450.194Z" fill="white"/>
        	<path d="M1376.39 925.832L1304.52 1099.35L1209 1113.91L1319.14 848L1376.39 925.832Z" fill="white"/>
        	<path d="M241.01 1099.36L169.135 925.833L226.381 848L336.525 1113.91L241.01 1099.36Z" fill="white"/>
        	<path d="M169.134 623.717L241.009 450.195L336.525 435.638L226.381 701.549L169.134 623.717Z" fill="white"/>
        	<defs>
        		<filter id="filter0_f" x="0" y="0" width="1545.53" height="1551.53" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
        			<feFlood flood-opacity="0" result="BackgroundImageFix"/>
        			<feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
        			<feGaussianBlur stdDeviation="75" result="effect1_foregroundBlur"/>
        		</filter>
        	</defs>
        </svg>
    ]],
	["RoundedBar"] = [[
        <svg width="500" height="500" viewBox="0 0 500 500" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect x="225" width="50" height="500" rx="25" fill="white"/>
        </svg>
    ]],
	["Circle"] = [[
        <svg width="200" height="200" viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg">
			<circle cx="100" cy="100" r="100" fill="white"/>
		</svg>
    ]],
}

SVG:CacheMaterials(OverdoneServers, mats)