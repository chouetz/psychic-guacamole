name 'qa-linux-agent7-unstable'
description 'Linux QA node running agent7 (unstable)'
default_attributes(
  'datadog' => {
    'agent_version' => '7.65.0~rc.5',
  }
)
