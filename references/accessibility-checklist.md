# Accessibility checklist

Use this for UI implementation and review.

## Keyboard and focus

- Every interactive element is reachable via keyboard.
- Focus order follows reading order.
- Visible focus indicator is always present.
- Skip-to-content link exists on multi-section pages.

## Semantics and labels

- Use semantic HTML before ARIA.
- Form controls have explicit labels.
- Icon-only controls have accessible names.
- Error messages are announced and tied to fields.

## Visual and content checks

- Text contrast meets WCAG AA.
- Content remains usable at 200% zoom.
- Motion has reduced-motion fallback.

## Red flags

- Click handlers on non-interactive elements.
- Placeholder-only labels for required fields.
- Missing form autocomplete for known fields.
