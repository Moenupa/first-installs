# --- templating ---
alias tp=template

# a create_using_template utility by github@moenupa
# It generates files according to a template
# this could be useful for sbatch, python scripts, etc.
# usage: template <template_name> <new_file_name>

template() {
	if [[ $# -eq 0 ]]; then
		echo "Usage: $0 <template_file> [destination]"
		return 1
	fi

	if [[ $# -eq 2 ]]; then
		# if $2 ends with $1, then do not append .$1
		if [[ "$2" == *"$1" ]]; then
			local destination="$2"
		else
			local destination="$2.$1"
		fi
	else
		local destination="./template.$1"
	fi

	local template="$HOME/.template/$1"
	local filename="$1"
	local destination="./tp.$filename"

	if [[ ! -f "$template" ]]; then
		echo "Error: Template '$template' does not exist."
		return 1
	fi
	if [[ -f "$destination" ]]; then
		echo "Error: Template '$destination' already exists."
		return 1
	fi

	if cp "$template" "$destination"; then
		echo "'$destination' <- '$template'."
	else
		echo "Error: Failed to copy template."
		return 1
	fi
}
_template_comp() {
	_arguments "1:template file:_files -W $HOME/.template -g '*' -/ -S ''"
}
compdef _template_comp template
