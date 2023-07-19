add-content -p c:/users/Gastón/.ssh/config -value @'

Host ${hostname}
    HostName ${hostname}
    User ${user}
    Identityfile ${Identityfile}
'@