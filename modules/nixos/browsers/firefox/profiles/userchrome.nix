{ pkgs, ... }:

{ 
  cascade = ''
    @import '${pkgs.arclight.firefox-cascade}/chrome/includes/cascade-config-mouse.css';
    @import '${pkgs.arclight.firefox-cascade}/chrome/includes/cascade-layout.css';
    @import '${pkgs.arclight.firefox-cascade}/chrome/includes/cascade-floating-panel.css';
    @import '${pkgs.arclight.firefox-cascade}/chrome/includes/cascade-nav-bar.css';
    @import '${pkgs.arclight.firefox-cascade}/chrome/includes/cascade-tabs.css';
    @import '${pkgs.arclight.firefox-cascade}/chrome/includes/cascade-colours.css';
    
    :root {
      --uc-urlbar-min-width: 0vw;
      --uc-urlbar-max-width: 100vw;
    }

    #tracking-protection-icon-container {
    	display: none !important;
    }
    
    #context-savepage, #context-sep-selectall, #context-take-screenshot {
      display: none !important;
    }

    #context-openlinkprivate, #context-sendimage, #context-sep-setbackground, #context-setDesktopBackground {
        display: none !important;
    }

    @media (min-width: 0px) {
      #navigator-toolbox { display: flex; flex-wrap: wrap; flex-direction: row; }

      #nav-bar {
        order: var(--uc-urlbar-position);
        width: var(--uc-urlbar-min-width);
      }

      #nav-bar #urlbar-container { min-width: 40px !important; width: auto !important; }

      #titlebar {
        order: 2;
        width: calc(100vw - var(--uc-urlbar-min-width) - 1px);
      }
    
      #PersonalToolbar {
        order: var(--uc-toolbar-position);
        width: 100%;
      }
    
      #navigator-toolbox:focus-within #nav-bar { width: var(--uc-urlbar-max-width); }
      #navigator-toolbox:focus-within #titlebar { width: calc(100vw - var(--uc-urlbar-max-width) - 1px); }
    
    }
  '';

autohide = ''
    @import "${pkgs.arclight.firefox-csshacks}/chrome/autohide_toolbox.css";
    
    :root{
      --uc-autohide-toolbox-delay: 1000ms; 
    }
    
    @media  (-moz-platform: linux){
      #navigator-toolbox:not(:-moz-lwtheme){ background-color: -moz-dialog !important; }
    }
  '';

nobar = ''
    #titlebar {
        visibility: collapse;
    }

    #navigator-toolbox {
        visibility: collapse;
    }
'';
}

