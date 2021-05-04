import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_bloc/cubit/movies_cubit.dart';

class TermInputField extends StatefulWidget {
  TermInputField({Key? key}) : super(key: key);

  @override
  _TermInputFieldState createState() => _TermInputFieldState();
}

class _TermInputFieldState extends State<TermInputField> {
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Term to search...',
            border: OutlineInputBorder(),
            suffixIcon: GestureDetector(
              onTap: () {
                final form = _formKey.currentState!;
                if (form.validate()) {
                  form.save();
                }
              },
              child: MouseRegion(
                child: Icon(Icons.search),
              ),
            ),
          ),
          onSaved: (term) =>
              context.read<MoviesCubit>().fetchMoviesByTerm(term!),
          validator: (term) =>
              term?.isEmpty == true ? 'The term field is required' : null,
        ),
      ),
    );
  }
}
