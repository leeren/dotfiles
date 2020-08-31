"Helper methods for evaluating UltiSnips"

def complete(t, opts):
  if t:
    opts = [ m[len(t):] for m in opts if m.startswith(t) ]
  if len(opts) == 1:
    return opts[0]
  if len(opts) == 0:
    return ''
  return '(' + '|'.join(opts) + ')'
