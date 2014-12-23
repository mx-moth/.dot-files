import subprocess


def get_password(name):
    pass_out = subprocess.check_output(['pass', 'show', name])
    return pass_out.split('\n')[0]
