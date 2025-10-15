.venv/.installed: .venv/pyvenv.cfg requirements.txt
	.venv/bin/pip install -r requirements.txt
	touch .venv/.installed

.venv/pyvenv.cfg:
	python3 -m venv .venv
