.DEFAULT_GOAL:=help
.PHONY: all help clean release major minor patch
.PRECIOUS:
SHELL:=/bin/bash

VERSION:=$(shell git describe --abbrev=0 --tags)
CURRENT_BRANCH:=$(shell git rev-parse --abbrev-ref HEAD)

help:
	@echo -e "\033[33mUsage:\033[0m\n  make TARGET\n\n\033[33mTargets:\033[0m"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-7s\033[0m %s\n", $$1, $$2}'

git_commit:
	@git add .
	@git commit -a -m "Auto" || true

git_push: git_commit
	@git push --all
	@git push --tags

get_forks:
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=1"  | jq -r '.[]| "	git remote add " + .owner.login + " " + .clone_url' | tee    _list_forks
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=2"  | jq -r '.[]| "	git remote add " + .owner.login + " " + .clone_url' | tee -a _list_forks
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=3"  | jq -r '.[]| "	git remote add " + .owner.login + " " + .clone_url' | tee -a _list_forks
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=4"  | jq -r '.[]| "	git remote add " + .owner.login + " " + .clone_url' | tee -a _list_forks
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=5"  | jq -r '.[]| "	git remote add " + .owner.login + " " + .clone_url' | tee -a _list_forks
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=6"  | jq -r '.[]| "	git remote add " + .owner.login + " " + .clone_url' | tee -a _list_forks
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=7"  | jq -r '.[]| "	git remote add " + .owner.login + " " + .clone_url' | tee -a _list_forks
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=8"  | jq -r '.[]| "	git remote add " + .owner.login + " " + .clone_url' | tee -a _list_forks
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=9"  | jq -r '.[]| "	git remote add " + .owner.login + " " + .clone_url' | tee -a _list_forks
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=10" | jq -r '.[]| "	git remote add " + .owner.login + " " + .clone_url' | tee -a _list_forks
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=11" | jq -r '.[]| "	git remote add " + .owner.login + " " + .clone_url' | tee -a _list_forks
	cat _list_forks | sort | uniq | tee _list_forks_sort
	rm _list_forks

gen_worktrees:
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=1"  | jq -r '.[]| "	git worktree add ../proxmox_hassio_lxc." + .owner.login + "; cd ../proxmox_hassio_lxc." + .owner.login + "; git checkout " + .owner.login + "/master"' | tee    _list_gen_worktree
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=2"  | jq -r '.[]| "	git worktree add ../proxmox_hassio_lxc." + .owner.login + "; cd ../proxmox_hassio_lxc." + .owner.login + "; git checkout " + .owner.login + "/master"' | tee -a _list_gen_worktree
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=3"  | jq -r '.[]| "	git worktree add ../proxmox_hassio_lxc." + .owner.login + "; cd ../proxmox_hassio_lxc." + .owner.login + "; git checkout " + .owner.login + "/master"' | tee -a _list_gen_worktree
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=4"  | jq -r '.[]| "	git worktree add ../proxmox_hassio_lxc." + .owner.login + "; cd ../proxmox_hassio_lxc." + .owner.login + "; git checkout " + .owner.login + "/master"' | tee -a _list_gen_worktree
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=5"  | jq -r '.[]| "	git worktree add ../proxmox_hassio_lxc." + .owner.login + "; cd ../proxmox_hassio_lxc." + .owner.login + "; git checkout " + .owner.login + "/master"' | tee -a _list_gen_worktree
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=6"  | jq -r '.[]| "	git worktree add ../proxmox_hassio_lxc." + .owner.login + "; cd ../proxmox_hassio_lxc." + .owner.login + "; git checkout " + .owner.login + "/master"' | tee -a _list_gen_worktree
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=7"  | jq -r '.[]| "	git worktree add ../proxmox_hassio_lxc." + .owner.login + "; cd ../proxmox_hassio_lxc." + .owner.login + "; git checkout " + .owner.login + "/master"' | tee -a _list_gen_worktree
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=8"  | jq -r '.[]| "	git worktree add ../proxmox_hassio_lxc." + .owner.login + "; cd ../proxmox_hassio_lxc." + .owner.login + "; git checkout " + .owner.login + "/master"' | tee -a _list_gen_worktree
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=9"  | jq -r '.[]| "	git worktree add ../proxmox_hassio_lxc." + .owner.login + "; cd ../proxmox_hassio_lxc." + .owner.login + "; git checkout " + .owner.login + "/master"' | tee -a _list_gen_worktree
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=10" | jq -r '.[]| "	git worktree add ../proxmox_hassio_lxc." + .owner.login + "; cd ../proxmox_hassio_lxc." + .owner.login + "; git checkout " + .owner.login + "/master"' | tee -a _list_gen_worktree
	curl -s "https://api.github.com/repos/whiskerz007/proxmox_hassio_lxc/forks?per_page=100&page=11" | jq -r '.[]| "	git worktree add ../proxmox_hassio_lxc." + .owner.login + "; cd ../proxmox_hassio_lxc." + .owner.login + "; git checkout " + .owner.login + "/master"' | tee -a _list_gen_worktree
	cat _list_gen_worktree | sort | uniq | tee _list_gen_worktree_sort
	rm _list_gen_worktree

bootstrap:
	git remote add Actpohomoc https://github.com/Actpohomoc/proxmox_hassio_lxc.git
	git remote add adampielak https://github.com/adampielak/proxmox_hassio_lxc.git
	git remote add ahuacate https://github.com/ahuacate/proxmox_hassio_lxc.git
	git remote add alexswart https://github.com/alexswart/proxmox_hassio_lxc.git
	git remote add anarion80 https://github.com/anarion80/proxmox_hassio_lxc.git
	git remote add arbal https://github.com/arbal/proxmox_hassio_lxc.git
	git remote add arturasaleknavicius https://github.com/arturasaleknavicius/proxmox_hassio_lxc.git
	git remote add arturdasilva https://github.com/arturdasilva/proxmox_hassio_lxc.git
	git remote add atarist https://github.com/atarist/proxmox_hassio_lxc.git
	git remote add A-vesalius https://github.com/A-vesalius/proxmox_hassio_lxc.git
	git remote add BrunoCunha1983 https://github.com/BrunoCunha1983/proxmox_hassio_lxc.git
	git remote add ccccc382 https://github.com/ccccc382/proxmox_hassio_lxc.git
	git remote add charliedgabriel https://github.com/charliedgabriel/proxmox_hassio_lxc.git
	git remote add cmileto https://github.com/cmileto/proxmox_hassio_lxc.git
	git remote add coreyvogt https://github.com/coreyvogt/proxmox_hassio_lxc.git
	git remote add crym761224 https://github.com/crym761224/proxmox_hassio_lxc.git
	git remote add danmed https://github.com/danmed/proxmox_hassio_lxc.git
	git remote add dazeb https://github.com/dazeb/proxmox_hassio_lxc.git
	git remote add dcossey014 https://github.com/dcossey014/proxmox_hassio_lxc.git
	git remote add dehness https://github.com/dehness/proxmox_hassio_lxc.git
	git remote add dendisuhubdy https://github.com/dendisuhubdy/proxmox_hassio_lxc.git
	git remote add dheath73 https://github.com/dheath73/proxmox_hassio_lxc.git
	git remote add domi1kenobi https://github.com/domi1kenobi/proxmox_hassio_lxc.git
	git remote add dziobson https://github.com/dziobson/proxmox_hassio_lxc.git
	git remote add electrostyle https://github.com/electrostyle/proxmox_hassio_lxc.git
	git remote add emile-bodin https://github.com/emile-bodin/proxmox_hassio_lxc.git
	git remote add fernandodpr https://github.com/fernandodpr/proxmox_hassio_lxc.git
	git remote add GerdRuetten https://github.com/GerdRuetten/proxmox_hassio_lxc.git
	git remote add GuiPoM https://github.com/GuiPoM/proxmox_hassio_lxc.git
	git remote add hursey013 https://github.com/hursey013/proxmox_hassio_lxc.git
	git remote add jabastien https://github.com/jabastien/proxmox_hassio_lxc.git
	git remote add jamait https://github.com/jamait/proxmox_hassio_lxc.git
	git remote add jannnfe https://github.com/jannnfe/proxmox_hassio_lxc.git
	git remote add Johannes123 https://github.com/Johannes123/proxmox_hassio_lxc.git
	git remote add jt-edwards https://github.com/jt-edwards/proxmox_hassio_lxc.git
	git remote add Justahobby01 https://github.com/Justahobby01/proxmox_hassio_lxc.git
	git remote add justme88 https://github.com/justme88/proxmox_hassio_lxc.git
	git remote add kenthinson https://github.com/kenthinson/hassio_lxc_aarch64.git
	git remote add leschNUX https://github.com/leschNUX/proxmox_hassio_lxc.git
	git remote add lsousa https://github.com/lsousa/proxmox_hassio_lxc.git
	git remote add MarcJenningsUK https://github.com/MarcJenningsUK/proxmox_nodered_lxc.git
	git remote add maxmax27 https://github.com/maxmax27/proxmox_hassio_lxc.git
	git remote add MaxTyutyunnikov https://github.com/MaxTyutyunnikov/proxmox_hassio_lxc.git
	git remote add meichthys https://github.com/meichthys/proxmox_hassio_lxc.git
	git remote add MeisterTR https://github.com/MeisterTR/proxmox_hassio_lxc.git
	git remote add mraes https://github.com/mraes/proxmox_hassio_lxc.git
	git remote add nnssz https://github.com/nnssz/proxmox_hassio_lxc.git
	git remote add paarak https://github.com/paarak/proxmox_hassio_lxc.git
	git remote add PascalKern https://github.com/PascalKern/proxmox_hassio_lxc.git
	git remote add patrickvanreck https://github.com/patrickvanreck/proxmox_hassio_lxc.git
	git remote add PopinjayJohn https://github.com/PopinjayJohn/proxmox_hassio_lxc.git
	git remote add quenthal https://github.com/quenthal/proxmox_hassio_lxc.git
	git remote add rheinbuch https://github.com/rheinbuch/proxmox_hassio_lxc.git
	git remote add rkkoszewski https://github.com/rkkoszewski/proxmox_hassio_lxc.git
	git remote add roman7488 https://github.com/roman7488/proxmox_hassio_lxc.git
	git remote add rudironsonijr https://github.com/rudironsonijr/proxmox_hassio_lxc.git
	git remote add Saberwolf64 https://github.com/Saberwolf64/proxmox_hassio_lxc.git
	git remote add seanvm https://github.com/seanvm/proxmox_hassio_lxc.git
	git remote add Shaman2 https://github.com/Shaman2/proxmox_hassio_lxc.git
	git remote add TeckyTec https://github.com/TeckyTec/proxmox_hassio_lxc.git
	git remote add Terit https://github.com/Terit/proxmox_hassio_lxc.git
	git remote add Tftlegal https://github.com/Tftlegal/proxmox_hassio_lxc.git
	git remote add thiscantbeserious https://github.com/thiscantbeserious/lxd_homeassistant_install.git
	git remote add TimApplepie https://github.com/TimApplepie/proxmox_hassio_lxc.git
	git remote add timmo001 https://github.com/timmo001/proxmox_hassio_lxc.git
	git remote add Toolmaster30 https://github.com/Toolmaster30/proxmox_hassio_lxc.git
	git remote add Valcob https://github.com/Valcob/proxmox_hassio_lxc.git
	git remote add valeur01 https://github.com/valeur01/proxmox_hassio_lxc.git
	git remote add vicelikedust https://github.com/vicelikedust/proxmox_hassio_lxc.git
	git remote add vukhanhthuy https://github.com/vukhanhthuy/proxmox_hassio_lxc.git
	git remote add xiki808 https://github.com/xiki808/proxmox-hassio-lxc.git
	git remote add Yasin0ps https://github.com/Yasin0ps/proxmox_hassio_lxc.git
	git remote add YGBM https://github.com/YGBM/proxmox_hassio_lxc.git
	git remote add ZwerG-MaX https://github.com/ZwerG-MaX/proxmox_hassio_lxc.git
	git remote add whiskerz007 https://github.com/whiskerz007/proxmox_hassio_lxc

worktrees:
	git worktree add ../proxmox_hassio_lxc.adampielak; cd ../proxmox_hassio_lxc.adampielak; git checkout adampielak/master
	git worktree add ../proxmox_hassio_lxc.alexswart; cd ../proxmox_hassio_lxc.alexswart; git checkout alexswart/master
	git worktree add ../proxmox_hassio_lxc.anarion80; cd ../proxmox_hassio_lxc.anarion80; git checkout anarion80/master
	git worktree add ../proxmox_hassio_lxc.arbal; cd ../proxmox_hassio_lxc.arbal; git checkout arbal/master
	git worktree add ../proxmox_hassio_lxc.arturasaleknavicius; cd ../proxmox_hassio_lxc.arturasaleknavicius; git checkout arturasaleknavicius/master
	git worktree add ../proxmox_hassio_lxc.arturdasilva; cd ../proxmox_hassio_lxc.arturdasilva; git checkout arturdasilva/master
	git worktree add ../proxmox_hassio_lxc.atarist; cd ../proxmox_hassio_lxc.atarist; git checkout atarist/master
	git worktree add ../proxmox_hassio_lxc.ccccc382; cd ../proxmox_hassio_lxc.ccccc382; git checkout ccccc382/master
	git worktree add ../proxmox_hassio_lxc.charliedgabriel; cd ../proxmox_hassio_lxc.charliedgabriel; git checkout charliedgabriel/master
	git worktree add ../proxmox_hassio_lxc.cmileto; cd ../proxmox_hassio_lxc.cmileto; git checkout cmileto/master
	git worktree add ../proxmox_hassio_lxc.coreyvogt; cd ../proxmox_hassio_lxc.coreyvogt; git checkout coreyvogt/master
	git worktree add ../proxmox_hassio_lxc.crym761224; cd ../proxmox_hassio_lxc.crym761224; git checkout crym761224/master
	git worktree add ../proxmox_hassio_lxc.danmed; cd ../proxmox_hassio_lxc.danmed; git checkout danmed/master
	git worktree add ../proxmox_hassio_lxc.dazeb; cd ../proxmox_hassio_lxc.dazeb; git checkout dazeb/master
	git worktree add ../proxmox_hassio_lxc.dcossey014; cd ../proxmox_hassio_lxc.dcossey014; git checkout dcossey014/master
	git worktree add ../proxmox_hassio_lxc.dehness; cd ../proxmox_hassio_lxc.dehness; git checkout dehness/master
	git worktree add ../proxmox_hassio_lxc.dendisuhubdy; cd ../proxmox_hassio_lxc.dendisuhubdy; git checkout dendisuhubdy/master
	git worktree add ../proxmox_hassio_lxc.dheath73; cd ../proxmox_hassio_lxc.dheath73; git checkout dheath73/master
	git worktree add ../proxmox_hassio_lxc.domi1kenobi; cd ../proxmox_hassio_lxc.domi1kenobi; git checkout domi1kenobi/master
	git worktree add ../proxmox_hassio_lxc.dziobson; cd ../proxmox_hassio_lxc.dziobson; git checkout dziobson/master
	git worktree add ../proxmox_hassio_lxc.emile-bodin; cd ../proxmox_hassio_lxc.emile-bodin; git checkout emile-bodin/master
	git worktree add ../proxmox_hassio_lxc.fernandodpr; cd ../proxmox_hassio_lxc.fernandodpr; git checkout fernandodpr/master
	git worktree add ../proxmox_hassio_lxc.hursey013; cd ../proxmox_hassio_lxc.hursey013; git checkout hursey013/master
	git worktree add ../proxmox_hassio_lxc.jabastien; cd ../proxmox_hassio_lxc.jabastien; git checkout jabastien/master
	git worktree add ../proxmox_hassio_lxc.jamait; cd ../proxmox_hassio_lxc.jamait; git checkout jamait/master
	git worktree add ../proxmox_hassio_lxc.jannnfe; cd ../proxmox_hassio_lxc.jannnfe; git checkout jannnfe/master
	git worktree add ../proxmox_hassio_lxc.Johannes123; cd ../proxmox_hassio_lxc.Johannes123; git checkout Johannes123/master
	git worktree add ../proxmox_hassio_lxc.jt-edwards; cd ../proxmox_hassio_lxc.jt-edwards; git checkout jt-edwards/master
	git worktree add ../proxmox_hassio_lxc.Justahobby01; cd ../proxmox_hassio_lxc.Justahobby01; git checkout Justahobby01/master
	git worktree add ../proxmox_hassio_lxc.justme88; cd ../proxmox_hassio_lxc.justme88; git checkout justme88/master
	git worktree add ../proxmox_hassio_lxc.kenthinson; cd ../proxmox_hassio_lxc.kenthinson; git checkout kenthinson/master
	git worktree add ../proxmox_hassio_lxc.lsousa; cd ../proxmox_hassio_lxc.lsousa; git checkout lsousa/master
	git worktree add ../proxmox_hassio_lxc.maxmax27; cd ../proxmox_hassio_lxc.maxmax27; git checkout maxmax27/master
	git worktree add ../proxmox_hassio_lxc.MeisterTR; cd ../proxmox_hassio_lxc.MeisterTR; git checkout MeisterTR/master
	git worktree add ../proxmox_hassio_lxc.mraes; cd ../proxmox_hassio_lxc.mraes; git checkout mraes/master
	git worktree add ../proxmox_hassio_lxc.nnssz; cd ../proxmox_hassio_lxc.nnssz; git checkout nnssz/master
	git worktree add ../proxmox_hassio_lxc.PascalKern; cd ../proxmox_hassio_lxc.PascalKern; git checkout PascalKern/master
	git worktree add ../proxmox_hassio_lxc.patrickvanreck; cd ../proxmox_hassio_lxc.patrickvanreck; git checkout patrickvanreck/master
	git worktree add ../proxmox_hassio_lxc.PopinjayJohn; cd ../proxmox_hassio_lxc.PopinjayJohn; git checkout PopinjayJohn/master
	git worktree add ../proxmox_hassio_lxc.quenthal; cd ../proxmox_hassio_lxc.quenthal; git checkout quenthal/master
	git worktree add ../proxmox_hassio_lxc.rheinbuch; cd ../proxmox_hassio_lxc.rheinbuch; git checkout rheinbuch/master
	git worktree add ../proxmox_hassio_lxc.rkkoszewski; cd ../proxmox_hassio_lxc.rkkoszewski; git checkout rkkoszewski/master
	git worktree add ../proxmox_hassio_lxc.roman7488; cd ../proxmox_hassio_lxc.roman7488; git checkout roman7488/master
	git worktree add ../proxmox_hassio_lxc.rudironsonijr; cd ../proxmox_hassio_lxc.rudironsonijr; git checkout rudironsonijr/master
	git worktree add ../proxmox_hassio_lxc.Saberwolf64; cd ../proxmox_hassio_lxc.Saberwolf64; git checkout Saberwolf64/master
	git worktree add ../proxmox_hassio_lxc.seanvm; cd ../proxmox_hassio_lxc.seanvm; git checkout seanvm/master
	git worktree add ../proxmox_hassio_lxc.Shaman2; cd ../proxmox_hassio_lxc.Shaman2; git checkout Shaman2/master
	git worktree add ../proxmox_hassio_lxc.TeckyTec; cd ../proxmox_hassio_lxc.TeckyTec; git checkout TeckyTec/master
	git worktree add ../proxmox_hassio_lxc.Terit; cd ../proxmox_hassio_lxc.Terit; git checkout Terit/master
	git worktree add ../proxmox_hassio_lxc.Tftlegal; cd ../proxmox_hassio_lxc.Tftlegal; git checkout Tftlegal/master
	git worktree add ../proxmox_hassio_lxc.thiscantbeserious; cd ../proxmox_hassio_lxc.thiscantbeserious; git checkout thiscantbeserious/master
	git worktree add ../proxmox_hassio_lxc.TimApplepie; cd ../proxmox_hassio_lxc.TimApplepie; git checkout TimApplepie/master
	git worktree add ../proxmox_hassio_lxc.Toolmaster30; cd ../proxmox_hassio_lxc.Toolmaster30; git checkout Toolmaster30/master
	git worktree add ../proxmox_hassio_lxc.valeur01; cd ../proxmox_hassio_lxc.valeur01; git checkout valeur01/master
	git worktree add ../proxmox_hassio_lxc.vicelikedust; cd ../proxmox_hassio_lxc.vicelikedust; git checkout vicelikedust/master
	git worktree add ../proxmox_hassio_lxc.vukhanhthuy; cd ../proxmox_hassio_lxc.vukhanhthuy; git checkout vukhanhthuy/master
	git worktree add ../proxmox_hassio_lxc.xiki808; cd ../proxmox_hassio_lxc.xiki808; git checkout xiki808/master
	git worktree add ../proxmox_hassio_lxc.Yasin0ps; cd ../proxmox_hassio_lxc.Yasin0ps; git checkout Yasin0ps/master
	git worktree add ../proxmox_hassio_lxc.YGBM; cd ../proxmox_hassio_lxc.YGBM; git checkout YGBM/master
	git worktree add ../proxmox_hassio_lxc.ZwerG-MaX; cd ../proxmox_hassio_lxc.ZwerG-MaX; git checkout ZwerG-MaX/master
	git worktree add ../proxmox_hassio_lxc.whiskerz007; cd ../proxmox_hassio_lxc.whiskerz007; git checkout whiskerz007/master

compare:
#	meld ./ ../proxmox_hassio_lxc.TeckyTec
#	meld ./ ../proxmox_hassio_lxc.PopinjayJohn
#	meld ./ ../proxmox_hassio_lxc.rheinbuch
#	meld ./ ../proxmox_hassio_lxc.Toolmaster30
#	meld ./ ../proxmox_hassio_lxc.domi1kenobi
#	meld ./ ../proxmox_hassio_lxc.Johannes123
#	meld ./ ../proxmox_hassio_lxc.emile-bodin
#	meld ./ ../proxmox_hassio_lxc.jt-edwards
#	meld ./ ../proxmox_hassio_lxc.dheath73
#	meld ./ ../proxmox_hassio_lxc.Terit
#	meld ./ ../proxmox_hassio_lxc.alexswart
#	meld ./ ../proxmox_hassio_lxc.lsousa
#	meld ./ ../proxmox_hassio_lxc.Actpohomoc
#	meld ./ ../proxmox_hassio_lxc.MeisterTR
#	meld ./ ../proxmox_hassio_lxc.dehness
#	meld ./ ../proxmox_hassio_lxc.jannnfe
#	meld ./ ../proxmox_hassio_lxc.justme88
#	meld ./ ../proxmox_hassio_lxc.vicelikedust
#	meld ./ ../proxmox_hassio_lxc.thiscantbeserious
#	meld ./ ../proxmox_hassio_lxc.Johannes123
#	meld ./ ../proxmox_hassio_lxc.Shaman2
#	meld ./ ../proxmox_hassio_lxc.TeckyTec
#	meld ./ ../proxmox_hassio_lxc.Tftlegal
#	meld ./ ../proxmox_hassio_lxc.YGBM
#	meld ./ ../proxmox_hassio_lxc.ZwerG-MaX
#	meld ./ ../proxmox_hassio_lxc.anarion80
#	meld ./ ../proxmox_hassio_lxc.arturdasilva
#	meld ./ ../proxmox_hassio_lxc.ccccc382
#	meld ./ ../proxmox_hassio_lxc.cmileto
#	meld ./ ../proxmox_hassio_lxc.crym761224
#	meld ./ ../proxmox_hassio_lxc.danmed
#	meld ./ ../proxmox_hassio_lxc.dazeb
#	meld ./ ../proxmox_hassio_lxc.dziobson
#	meld ./ ../proxmox_hassio_lxc.fernandodpr
#	meld ./ ../proxmox_hassio_lxc.jabastien
#	meld ./ ../proxmox_hassio_lxc.jamait
#	meld ./ ../proxmox_hassio_lxc.justme88
#	meld ./ ../proxmox_hassio_lxc.maxmax27
#	meld ./ ../proxmox_hassio_lxc.nnssz
#	meld ./ ../proxmox_hassio_lxc.patrickvanreck
#	meld ./ ../proxmox_hassio_lxc.quenthal
#	meld ./ ../proxmox_hassio_lxc.roman7488
#	meld ./ ../proxmox_hassio_lxc.rudironsonijr
#	meld ./ ../proxmox_hassio_lxc.valeur01
#	meld ./ ../proxmox_hassio_lxc.vukhanhthuy
#	meld ./ ../proxmox_hassio_lxc.PascalKern
#	meld ./ ../proxmox_hassio_lxc.xiki808
#	meld ./ ../proxmox_hassio_lxc.PascalKern
#	meld ./ ../proxmox_hassio_lxc.TimApplepie
#	meld ./ ../proxmox_hassio_lxc.kenthinson
#	meld ./ ../proxmox_hassio_lxc.Justahobby01
#	meld ./ ../proxmox_hassio_lxc.Yasin0ps

d:
	git worktree remove ../proxmox_hassio_lxc.A-vesalius || :
	git worktree remove ../proxmox_hassio_lxc.Actpohomoc || :
	git worktree remove ../proxmox_hassio_lxc.BrunoCunha1983 || :
	git worktree remove ../proxmox_hassio_lxc.GerdRuetten || :
	git worktree remove ../proxmox_hassio_lxc.GerdRuetten || :
	git worktree remove ../proxmox_hassio_lxc.Johannes123 || :
	git worktree remove ../proxmox_hassio_lxc.MaxTyutyunnikov || :
	git worktree remove ../proxmox_hassio_lxc.MeisterTR || :
	git worktree remove ../proxmox_hassio_lxc.PascalKern || :
	git worktree remove ../proxmox_hassio_lxc.Shaman2 || :
	git worktree remove ../proxmox_hassio_lxc.TeckyTec || :
	git worktree remove ../proxmox_hassio_lxc.Terit || :
	git worktree remove ..//proxmox_hassio_lxc.Tftlegal || :
	git worktree remove ..//proxmox_hassio_lxc.Toolmaster30 || :
	git worktree remove ..//proxmox_hassio_lxc.YGBM || :
	git worktree remove ..//proxmox_hassio_lxc.ZwerG-MaX || :
	git worktree remove ..//proxmox_hassio_lxc.adampielak || :
	git worktree remove ..//proxmox_hassio_lxc.alexswart || :
	git worktree remove ..//proxmox_hassio_lxc.anarion80 || :
	git worktree remove ..//proxmox_hassio_lxc.arturasaleknavicius || :
	git worktree remove ..//proxmox_hassio_lxc.arturdasilva || :
	git worktree remove ..//proxmox_hassio_lxc.ccccc382 || :
	git worktree remove ..//proxmox_hassio_lxc.charliedgabriel || :
	git worktree remove ..//proxmox_hassio_lxc.cmileto || :
	git worktree remove ..//proxmox_hassio_lxc.crym761224 || :
	git worktree remove ../proxmox_hassio_lxc.whiskerz007/ || :
	git worktree remove ../proxmox_hassio_lxc.vukhanhthuy/ || :
	git worktree remove ../proxmox_hassio_lxc.valeur01/ || :
	git worktree remove ../proxmox_hassio_lxc.rudironsonijr/ || :
	git worktree remove ../proxmox_hassio_lxc.roman7488/ || :
	git worktree remove ../proxmox_hassio_lxc.rheinbuch/ || :
	git worktree remove ../proxmox_hassio_lxc.quenthal/ || :
	git worktree remove ../proxmox_hassio_lxc.patrickvanreck/ || :
	git worktree remove ../proxmox_hassio_lxc.nnssz/ || :
	git worktree remove ../proxmox_hassio_lxc.maxmax27/ || :
	git worktree remove ../proxmox_hassio_lxc.justme88/ || :
	git worktree remove ../proxmox_hassio_lxc.jamait/ || :
	git worktree remove ../proxmox_hassio_lxc.jabastien/ || :
	git worktree remove ../proxmox_hassio_lxc.fernandodpr/ || :
	git worktree remove ../proxmox_hassio_lxc.emile-bodin/ || :
	git worktree remove ../proxmox_hassio_lxc.dziobson/ || :
	git worktree remove ../proxmox_hassio_lxc.dazeb/ || :
	git worktree remove ../proxmox_hassio_lxc.danmed/ || :
	git worktree remove ../proxmox_hassio_lxc.crym761224/ || :
	git worktree remove ../proxmox_hassio_lxc.cmileto/ || :
	git worktree remove ..//proxmox_hassio_lxc.dehness || :
	git worktree remove ..//proxmox_hassio_lxc.dheath73 || :
	git worktree remove ..//proxmox_hassio_lxc.domi1kenobi || :
	git worktree remove ..//proxmox_hassio_lxc.hursey013 || :
	git worktree remove ..//proxmox_hassio_lxc.jannnfe || :
	git worktree remove ..//proxmox_hassio_lxc.thiscantbeserious || :
	git worktree remove ..//proxmox_hassio_lxc.vicelikedust || :
	git worktree remove ..//proxmox_hassio_lxc.xiki808 || :
	git worktree remove ..//proxmox_hassio_lxc.Saberwolf64 || :
	git worktree remove ..//proxmox_hassio_lxc.TimApplepie || :
	git worktree remove ..//proxmox_hassio_lxc.arbal || :
	git worktree remove ..//proxmox_hassio_lxc.atarist || :
	git worktree remove ..//proxmox_hassio_lxc.coreyvogt || :
	git worktree remove ..//proxmox_hassio_lxc.dcossey014 || :
	git worktree remove ..//proxmox_hassio_lxc.jt-edwards || :
	git worktree remove ..//proxmox_hassio_lxc.lsousa || :
	git worktree remove ..//proxmox_hassio_lxc.kenthinson || :
	git worktree remove ..//proxmox_hassio_lxc.seanvm || :
	git worktree remove ..//proxmox_hassio_lxc.rkkoszewski || :
	git worktree remove ..//proxmox_hassio_lxc.mraes || :
	git worktree remove ..//proxmox_hassio_lxc.dendisuhubdy || :
	git worktree remove ..//proxmox_hassio_lxc.Yasin0ps || :
	git worktree remove ..//proxmox_hassio_lxc.PopinjayJohn || :
#	git worktree remove ../ || :
#	git worktree remove ../ || :
#	git worktree remove ../ || :
