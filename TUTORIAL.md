# Getting Started: A Conceptual Walkthrough

This tutorial provides a high-level, conceptual walkthrough of how one might interact with a running HyperNARS system. The goal is to illustrate the flow of information and the roles of the core data types, without getting into implementation-specific details.

## The Goal: Teaching and Querying

Our goal is simple:
1.  Teach the system a few basic facts about the world.
2.  Ask the system a question based on those facts.
3.  Give the system a goal to achieve.

---

### Step 1: Injecting Knowledge (Beliefs)

First, we need to provide the system with some knowledge. We do this by sending it `Belief` sentences. A `Belief` represents something the system should treat as a fact.

Let's teach it two facts: "A cat is a type of mammal" and "Mammals have fur."

Conceptually, we would provide the following atoms to the system's API:

-   `(Belief <cat --> mammal> (TruthValue 1.0 0.99))`
-   `(Belief <mammal --> has-fur> (TruthValue 1.0 0.99))`

The system now absorbs these into its `Memory`. Each `Belief` is wrapped in a `Task` with a certain `Budget` (attention), and the reasoning loop processes it.

### Step 2: Asking a Question

Now that the system has some knowledge, we can ask it a question. A `Question` is a request for information. Let's ask it, "What properties does a cat have?"

We would provide the following `Question` sentence to the API:

-   `(Question <cat --> ?what>)`

The `?what` is a variable that we want the system to fill in.

### Step 3: How the System Reasons

Upon receiving the `Question` task, the system's `Control Loop` gets to work. Here's a simplified, conceptual view of what happens:

1.  The system identifies the core concept in the question: `cat`.
2.  It looks at the knowledge it has associated with `cat`, including the belief `<cat --> mammal>`.
3.  It also knows about `mammal`, and remembers the belief `<mammal --> has-fur>`.
4.  The `MeTTa Interpreter` applies a reasoning rule (like NAL's **Deduction**) to these two beliefs:
    -   IF `<cat --> mammal>` AND `<mammal --> has-fur>`
    -   THEN `<cat --> has-fur>`
5.  This newly derived belief, `<cat --> has-fur>`, directly answers the question.
6.  The system would then present this answer back to the user.

### Step 4: Adding a Goal

Now, let's give the system a `Goal`. A `Goal` is a state of the world the system should try to achieve. Let's say our goal is to have a pet cat.

We could express this with a `Goal` sentence:

-   `(Goal (user-has-pet cat))`

### Step 5: Grounding and Acting

When the system processes this `Goal`, its `Goal & Planning Function` will activate.

1.  The system searches its memory for beliefs about how to achieve the goal `(user-has-pet cat)`.
2.  It might find a procedural belief like: `(<(execute adopt-cat-action)> ==> (user-has-pet cat))`. This means, "Executing the 'adopt cat' action leads to the user having a pet cat."
3.  This belief tells the system it has a way to achieve the goal. The `execute-action` term is a special **Grounded Atom**.
4.  The system would then form the intention to execute this action. The `Grounded Atom Interface` would translate this symbolic action into a real-world effect (which, in a real application, might mean sending an email, controlling a robot, or displaying a button on a UI).

---

## Conclusion

This walkthrough illustrates the basic interaction pattern with HyperNARS:

-   We provide it with **Beliefs** to build its knowledge base.
-   We ask it **Questions** to retrieve information, triggering its reasoning process.
-   We give it **Goals** to achieve, triggering its planning and action capabilities.

This entire process is mediated by the core data structures of `Atom`, `Sentence`, and `Task`, and driven by the continuous reasoning loop.
