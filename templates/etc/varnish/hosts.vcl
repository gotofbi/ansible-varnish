{% for backend in varnish_backend_hosts %}
backend application_{{ loop.index }} {
  .host = "{{ backend }}";
  .port = "{{ varnish_backend_port }}";
{% if varnish_health_checks_enabled %}
  .probe = {
    .url = "{{ varnish_health_check_url }}";
    .interval = {{ varnish_health_check_interval }};
    .timeout  = {{ varnish_health_check_timeout }};
    .window = {{ varnish_health_check_window }};
    .threshold = {{ varnish_health_check_threshold }};
  }
{% endif %}
}
{% endfor %}

