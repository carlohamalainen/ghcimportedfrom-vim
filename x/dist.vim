let s:version = join(ghcimportedfrom#version(), '.')
echo system(printf('git archive --prefix=ghcimportedfrom-vim-%s/ -o ghcimportedfrom-vim-%s.zip v%s after autoload doc', s:version, s:version, s:version))
