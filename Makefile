temp-bridges:
	mkdir -p dist
	openscad -o dist/spool-holder.stl src/spool-holder.scad

format:
	prettier -w README.md
