# name: clearance
# ---------------
# Based on idan. Display the following bits on the left:
# - Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# - Current directory name
# - Git branch and dirty state (if inside a git repo)

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _duration
  if [ ! $CMD_DURATION ]
    return
  end

  echo -n ' '

  if [ $CMD_DURATION -lt 1000 ] # less than 1 second
    echo -n $CMD_DURATION'ms'
    return
  end
  
  set millis (math $CMD_DURATION \% 1000)
  set seconds (math $CMD_DURATION / 1000)
  if [ $seconds -lt 60 ]
    echo -n "$seconds $millis" | awk '{printf "%ds%03dms", $1, $2}'
    return
  end

  set minutes (math $seconds / 60)
  set seconds (math $seconds \% 60)
  if [ $minutes -lt 60 ]
    echo -n "$minutes $seconds $millis" | awk '{printf "%dm%02ds%03dms", $1, $2, $3}'
    return
  end

  set hours (math $minutes / 60)
  set minutes (math $minutes \% 60)
  echo -n "$hours $minutes $seconds $millis" | awk '{printf "%dh%02dm%02ds%03dms", $1, $2, $3, $4}'
end

function fish_prompt
  set -l last_status $status

  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l normal (set_color normal)

  set -l cwd $yellow(pwd | sed "s:^$HOME:~:")

  # Output the prompt, left to right

  # Add a newline before new prompts
  # echo -e ''

  # Display [venvname] if in a virtualenv
  # if set -q VIRTUAL_ENV
  #     echo -n -s (set_color -b normal white) '[' (basename "$VIRTUAL_ENV") ']' $normal ' '
  # end

  # Print pwd or full path
  echo -n -s $cwd $normal

  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info '(' $yellow $git_branch "±" $normal ')'
    else
      set git_info '(' $green $git_branch $normal ')'
    end
    echo -n -s ' · ' $git_info $normal
  end

  echo -n (_duration)

  set -l prompt_color $red
  if test $last_status = 0
    set prompt_color $normal
  end

  # Terminate with a nice prompt char
  echo -e ''
  echo -e -n -s $prompt_color '$ ' $normal
end
