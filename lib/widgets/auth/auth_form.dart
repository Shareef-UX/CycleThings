import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading, this.isSignUp);

  final bool isLoading;
  final bool isSignUp;
  final void Function(
    String email,
    String password,
    String userName,
    String idmatric,
    String address,
    String gender,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _idmatric = '';
  var _address = '';
  var _gender = '';

  void initState() {
    super.initState();
    _isLogin = widget.isSignUp;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _idmatric.trim(),
        _address,
        _gender,
        _isLogin,
        context,
      );
      // Use those values to send our auth reques ....
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('txtemail'),
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@')) {
                        return 'Pleas enter a valid email address!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    onSaved: (val) {
                      _userEmail = val;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('txtpassword'),
                    validator: (val) {
                      if (val.isEmpty || val.length < 7) {
                        return 'Password must be at least 7 characters long!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    obscureText: true,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('txtusername'),
                      validator: (val) {
                        if (val.isEmpty || val.length < 4) {
                          return 'Please enter at least 4 characters!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      onSaved: (val) {
                        _userName = val;
                      },
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('txtidmatric'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter at valid id number!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'ID Number(Matric/IC)',
                      ),
                      onSaved: (val) {
                        _idmatric = val;
                      },
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('txtaddress'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter at valid address!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                      onSaved: (val) {
                        _address = val;
                      },
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('txtgender'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter at valid gender!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Gender',
                      ),
                      onSaved: (val) {
                        _gender = val;
                      },
                    ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? 'Login' : 'SignUp'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor),
                      child: Text(_isLogin
                          ? 'Create new acount'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
